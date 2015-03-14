class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    # https://github.com/plataformatec/devise/blob/master/app/controllers/devise/registrations_controller.rb#L14
    build_resource(sign_up_params)
    resource.skip_confirmation!
    resource.save!

    # yield start
    resource.add_role :customer

    profile_params = {
      user_id: resource.id,
      share_link_code: User.generate_share_link_code,
      province: params[:province],
      city: params[:city],
      region: params[:region]
    }
    profile = Profile.new(profile_params)

    User.with_any_role(:provider, :admin).each do |u|
      p = u.profile
      if p.province == profile.province && p.city == profile.city && p.region == profile.region
        profile.supplier_id = u.id
      else
        profile.supplier_id = User.with_role(:admin).first.id
      end
    end
    profile.save!

    Integral.create(user_id: resource.id, amount: 0)
    Vritualcard.create(user_id: resource.id, money: '0.00')
    Score.create(user_id: resource.id, mark: 0)

    sign_in(resource) if resource.persisted?
    # yield end
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def set_minimum_password_length
    if devise_mapping.validatable?
      @minimum_password_length = resource_class.password_length.min
    end
  end
end

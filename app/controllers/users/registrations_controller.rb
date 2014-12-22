class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super
    resource.add_role :customer

    profile_params = {
      user_id: resource.id,
      invite_code: User.generate_invite_code,
      province: params[:province],
      city: params[:city],
      region: params[:region]
    }
    profile = Profile.new(profile_params)

    User.with_any_role(:provider, :admin).each do |p|
      if p.profile.province = profile.province && p.profile.city = profile.city && p.profile.region = profile.region
        profile.supplier_id = p.id
      else
        profile.supplier_id = User.with_role(:admin).first.id
      end
    end
    puts '==' * 20
    puts profile.supplier_id
    puts User.with_role(:admin)
    profile.save

    Integral.create(user_id: resource.id, amount: 0)
    Vritualcard.create(user_id: resource.id, money: '0.00')
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
end

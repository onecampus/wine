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

    profile = Profile.new(
      user_id: resource.id,
      invite_code: User.generate_invite_code
      # share_link_code: User.generate_share_link_code
    )
    profile.save

    puts '==' * 20
    parent_invite_code = params[:invite_code]
    puts "parent_invite_code is #{parent_invite_code}"
    if parent_invite_code && parent_invite_code != ''
      puts "parent_invite_code is not nil and is #{parent_invite_code}"
      parent_user = Profile.where(invite_code: parent_invite_code).first
      unless parent_user.nil?
        profile.move_to_child_of(parent_user)
        parent_user.reload
      end
    end
    puts '==' * 20

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

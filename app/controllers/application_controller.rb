class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session
  # protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }
  # skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :authenticate_user!

  # check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def after_sign_in_path_for(resource)
    sign_in_url = url_for(action: 'new', controller: 'sessions', only_path: false, protocol: 'http')

    if request.referer == sign_in_url
      params[:back_url] ? params[:back_url] : super
    else
      if params[:back_url]
        params[:back_url] || stored_location_for(resource) || request.referer || root_path
      else
        stored_location_for(resource) || request.referer || root_path
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
    devise_parameter_sanitizer.for(:account_update) << :username
  end
end

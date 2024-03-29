class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :store_current_location, unless: :devise_controller?
  before_action :config_permit_params, if: :devise_controller?

  protect_from_forgery with: :exception

  protected

  def config_permit_params
    added_attrs = [:username, :email, :password, :password_confirmationm,
      :remember_me, :first_name, :last_name]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def require_log_in
    unless user_signed_in?
      flash[:error] = "You must be logged in"
      redirect_to account_path
    end
  end

  private

  def store_current_location
    # store last url as long as it isn't a /users path
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/account/
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      session[:previous_url] || landing_path
    elsif resource.is_a?(AdminUser)
      admin_dashboard_path(resource)
    end
  end

  def after_sign_out_path_for(resource)
    session[:previous_url] || landing_path
  end
end

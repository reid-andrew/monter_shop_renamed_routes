class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart,
                :current_user,
                :current_user?,
                :current_merchant?,
                :current_admin?,
                :logged_in?,
                :require_current_user,
                :require_merchant,
                :require_admin,
                :require_not_admin

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user?
    current_user && current_user.user?
  end

  def current_merchant?
    current_user && current_user.merchant?
  end

  def current_admin?
    current_user && current_user.admin?
  end

  def logged_in?
    session[:user_id].present?
  end

  def require_current_user
    render file: "/public/404" unless current_user
  end

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end

  def require_admin
    render file: "/public/404" unless current_admin?
  end

  def require_not_admin
    render file: "/public/404" if current_admin?
  end
end

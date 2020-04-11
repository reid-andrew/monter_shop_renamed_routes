class Profile::OrdersController < ApplicationController

  before_action :require_current_user

  def index
    @orders = current_user.orders
  end

  private

  def require_current_user
    render file: "/public/404" unless current_user
  end
end

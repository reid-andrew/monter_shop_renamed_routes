class Profile::OrdersController < ApplicationController

  before_action :require_current_user

  def index
    @orders = current_user.orders
  end

  def show
    @order = Order.find(order_params[:order_id])
  end

  private

  def order_params
    params.permit(:order_id)
  end
end

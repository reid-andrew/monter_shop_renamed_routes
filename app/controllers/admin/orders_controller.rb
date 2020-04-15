class Admin::OrdersController < ApplicationController

  before_action :require_admin

  def update
    @order = Order.find(order_params[:order_id])
    if order_params[:type] == "ship"
      @order.update(:status => "Shipped")
      @order.item_orders.each { |item_order| item_order.update(:status => "Shipped") }
    end
    redirect_to "/admin"
  end

  private

  def order_params
    params.permit(:order_id, :type)
  end
end

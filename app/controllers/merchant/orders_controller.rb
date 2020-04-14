class Merchant::OrdersController < ApplicationController


  def show
    @orders = current_user.merchant.orders.distinct
  end

  def update
    item = Item.find(params[:item_order_id])
    order = Order.find(params[:order_id])
    item_order = order.item_orders.where(:item_id => params[:item_order_id]).first
    item_order.status = "Fulfilled"
    item_order.save
    item.fulfilled_inventory(order.id)
    item.save
    flash[:success] = "Item has been fulfilled"
    redirect_to "/merchant/orders/#{order.id}"
  end
end

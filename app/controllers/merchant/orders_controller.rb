class Merchant::OrdersController < ApplicationController


  def show
    @orders = current_user.merchant.orders.distinct
  end

  def update    
    item_order = ItemOrder.find(item_order_params[:item_order_id])
    item_order.status = "Fulfilled"
    item_order.save
    flash[:success] = "Item has been fulfilled"
    redirect_to "/merchant/orders/#{order.id}"
  end
end

  private

  def item_order_params
    params.permit(:item_order_id, :type)
  end

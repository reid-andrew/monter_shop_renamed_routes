class OrdersController < ApplicationController

  before_action :require_current_user

  def new; end

  def create
    order = current_user.orders.new(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price - item.merchant.discount_eligible(quantity, item.price)
          })
      end
      flash[:success] = "Your order has been submitted!"
      session.delete(:cart)
      redirect_to "/profile/orders"
    else
      flash[:error] = "Please complete address form to create an order."
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(order_params[:order_id])
    if order_params[:type] == "cancel"
      @order.update(:status => "Canceled")
      @order.item_orders.each do |item_order|
        item_order.update(:status => "Unfulfilled")
      end
      flash[:cancel] = "Order ##{@order.id} has been canceled."
      redirect_to "/profile"
    end
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip, :type, :order_id)
  end
end

class OrdersController <ApplicationController

  def new; end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = current_user.orders.new(order_params)
    # # order = Order.create(order_params)
    # order.update
    # require "pry"; binding.pry
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      flash[:notice] = "Your order has been submitted!"
      session.delete(:cart)
      redirect_to "/profile/orders"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def index
    @orders = current_user.orders
  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end

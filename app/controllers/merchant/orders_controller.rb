class Merchant::OrdersController < ApplicationController


  def show
    @orders = current_user.merchant.orders.distinct  
  end

end

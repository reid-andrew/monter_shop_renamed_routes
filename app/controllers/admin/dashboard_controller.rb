class Admin::DashboardController < ApplicationController

  before_action :require_admin
  
  def index
    @orders = Order.orders_sorted_for_admin_display
  end
end

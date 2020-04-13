class Merchant::ItemsController < ApplicationController

  before_action :require_merchant

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end

  def index
    @items = @current_user.merchant.items
  end

  def update
    item = Item.find(params[:id])
    item.update(:active? => false)
    if item.save
      flash[:success] = "#{item.name} is no longer for sale"
      redirect_to "/merchant/items"
    end
  end

end

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
    if params[:status] == "deactivate"
      item.update(:active? => false)
    elsif params[:status] == "activate"
      item.update(:active? => true)
    end
    if item.save && params[:status] == "deactivate"
      flash[:success] = "#{item.name} is no longer for sale"
    elsif item.save && params[:status] == "activate"
      flash[:success] = "#{item.name} is now available for sale"
    else
      flash[:error] = "An error occurred"
    end
      redirect_to "/merchant/items"
  end

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    if item.destroy
      flash[:success] = "#{item.name} is now deleted"
    end
    redirect_to "/merchant/items"
  end

end

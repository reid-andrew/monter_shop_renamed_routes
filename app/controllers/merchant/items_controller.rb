class Merchant::ItemsController < ApplicationController

  before_action :require_merchant

  def require_merchant
    render file: "/public/404" unless current_merchant? || current_admin?
  end

  def new
    @item = Item.new
  end

  def create
    @merchant = @current_user.merchant
    @item = @merchant.items.create(item_params)
    if @item.save
      flash[:success] = "#{@item.name} is saved"
      redirect_to "/merchant/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  def index
    @items = @current_user.merchant.items
  end

  def update
    @item = Item.find(params[:id])
    if params[:status]
      if params[:status] == "deactivate"
        @item.update(:active? => false)
      elsif params[:status] == "activate"
        @item.update(:active? => true)
      end
      if @item.save && params[:status] == "deactivate"
        flash[:success] = "#{@item.name} is no longer for sale"
      elsif @item.save && params[:status] == "activate"
        flash[:success] = "#{@item.name} is now available for sale"
      end
      redirect_to "/merchant/items"
    else
      @item.update(item_params)
      if @item.save
        flash[:success] = "#{@item.name} is updated"
        redirect_to "/merchant/items"
      else
        flash[:error] = @item.errors.full_messages.to_sentence
        render :edit
      end
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    if item.destroy
      flash[:success] = "#{item.name} is now deleted"
    end
    redirect_to "/merchant/items"
  end

  private

  def item_params
    params.permit(:name, :description, :price, :inventory, :image)
  end


end

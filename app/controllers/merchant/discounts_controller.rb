class Merchant::DiscountsController < ApplicationController

  before_action :require_merchant

  def index
    @merchant = @current_user.merchant
  end

  def new; end

  def create
    @current_user.merchant.discounts.create(discount_params)
    redirect_to "/merchant/discounts"
  end

  def show
    @discount = Discount.find(discount_params[:id])
  end

  def edit
    @discount = Discount.find(discount_params[:id])
  end

  def update
    discount = Discount.find(discount_params[:id])
    discount.update(discount_params)
    redirect_to "/merchant/discounts"
  end


  private

  def discount_params
    params.permit(:id, :discount, :items)
  end
end

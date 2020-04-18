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

  private

  def discount_params
    params.permit(:discount, :items)
  end

end

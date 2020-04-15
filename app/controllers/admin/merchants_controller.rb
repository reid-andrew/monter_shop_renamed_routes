class Admin::MerchantsController < ApplicationController

  before_action :require_admin

  def require_admin
    render file: "/public/404" unless current_admin?
  end

  def index
    @merchants = Merchant.all
  end

  def update
    @merchant = Merchant.find(merchant_params[:merchant_id])
    if merchant_params[:type]
      update = merchant_params[:type] == "enable" ? true : false
      @merchant.update(:active => update)
      @merchant.items.each { |item| item.update(:active? => update) }
      flash[:update] = "#{@merchant.name}'s account has been #{merchant_params[:type]}d."
      redirect_to "/admin/merchants"
    end
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  private

  def merchant_params
    params.permit(:type, :merchant_id)
  end
end

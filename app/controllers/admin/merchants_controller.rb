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
    if merchant_params[:type] == "disable"
      @merchant.update(:active => false)
    redirect_to "/admin/merchants"
    flash[:success] = "#{@merchant.name}'s account has been disabled."
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

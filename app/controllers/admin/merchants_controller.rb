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
      @merchant.items.each do |item|
        item.update(:active? => false)
      end
      flash[:success] = "#{@merchant.name}'s account has been disabled."
    elsif
      merchant_params[:type] == "enable"
      @merchant.update(:active => true)
      flash[:success] = "#{@merchant.name}'s account has been enabled."
    end
      redirect_to "/admin/merchants"
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  private

  def merchant_params
    params.permit(:type, :merchant_id)
  end

end

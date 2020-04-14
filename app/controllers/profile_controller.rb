class ProfileController < ApplicationController

  before_action :require_user

  def require_user
    render file: "/public/404" unless current_user
  end

  def index
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(user_params)
    if @user.save
      flash[:success] = "Your profile is updated"
      redirect_to "/profile"
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def user_params
    params.permit(:name, :street_address, :city, :state, :zip, :email)
  end
end

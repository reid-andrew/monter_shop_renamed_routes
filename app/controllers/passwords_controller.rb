class PasswordsController < ApplicationController

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(password_params)
    if password_params[:password] != password_params[:password_confirmation]
      flash[:failure] = "Password and confirmation must match."
      render :edit
    elsif @user.save
      redirect_to '/profile'
      flash[:error] = "Your password has been updated"
    else
      flash[:failure] = "You are missing required fields."
      render :edit
    end
  end

  private

  def password_params
    params.permit(:password, :password_confirmation)
  end

end

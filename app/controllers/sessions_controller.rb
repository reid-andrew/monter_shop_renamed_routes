class SessionsController < ApplicationController

  def new
    if logged_in?
      redirect_by_role
      flash[:error] = "I'm already logged in"
    end
  end

  def create
    user = User.find_by(email: params[:email])

    if user.present? && user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success] = "Welcome, #{user.name}!"
        redirect_by_role
    else
      flash[:error] = "Sorry, your credentials are bad."
      flash[:error] += "Invalid email" if user.nil?
      flash[:error] += "Invalid password" if user.present?
      render :new
    end
  end

  def destroy
    binding.pry
    #
    # session.delete(:user_id)
    # redirect_to "/"
  end

  private

  def redirect_by_role
    redirect_to '/profile' if current_user?
    redirect_to '/merchant' if current_merchant?
    redirect_to '/admin' if current_admin?
  end

end

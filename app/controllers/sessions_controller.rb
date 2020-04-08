class SessionsController < ApplicationController

  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to '/profile' if current_user?
      redirect_to '/merchant' if current_merchant?
      redirect_to '/admin' if current_admin?

    else
      flash[:error] = "Sorry, your credentials are bad."
      render :new
    end
  end

end

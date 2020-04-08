class SessionsController < ApplicationController

  def new; end

  def create
    user = User.find_by(email: params[:email])

    if user.present? && user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success] = "Welcome, #{user.name}!"
        redirect_to '/profile' if current_user?
        redirect_to '/merchant' if current_merchant?
        redirect_to '/admin' if current_admin?
    else
      flash[:error] = "Sorry, your credentials are bad."
      flash[:error] += "Invalid email" if user.nil?
      flash[:error] += "Invalid password" if user.present?
      render :new
    end
  end

end

class UsersController<ApplicationController

  def show
    @user = User.find(session[:id])
  end

  def new; end

  def create
    user = User.create(user_params)
    session[:id] = user.id
    flash[:success] = "Welcome, #{user.name}! You are registered and logged in."
    redirect_to "/profile"
  end

  private

  def user_params
    params.permit(:name, :street_address, :city, :state, :zip, :email, :password_digest)
  end
end

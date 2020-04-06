class UsersController<ApplicationController

  def show
    @user = User.find(session[:id])
  end

  def new; end

  def create
    user = User.new(user_params)
    if user.save
      session[:id] = user.id
      flash[:success] = "Welcome, #{user.name}! You are registered and logged in."
      redirect_to "/profile"
    else
      flash[:failure] = "You are missing required fields."
      redirect_to "/register"
    end
  end

  private

  def user_params
    params.permit(:name, :street_address, :city, :state, :zip, :email, :password_digest)
  end
end

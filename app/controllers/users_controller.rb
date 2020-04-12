class UsersController<ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if User.where(email:@user.email) != []
      flash[:failure] = "That email address is already registered."
      render :new
    elsif @user.save
      session[:id] = @user.id
      @user.update(role: 0)
      flash[:success] = "Welcome, #{@user.name}! You are registered and logged in."
      redirect_to "/profile"
    else
      flash[:failure] = "You are missing required fields."
      render :new
    end
  end

  private

  def user_params
    params.permit(:name, :street_address, :city, :state, :zip, :email, :password, :password_confirmation)
  end
end

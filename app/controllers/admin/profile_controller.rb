class Admin::ProfileController < ApplicationController

  before_action :require_admin

  def index
    @users = User.all
  end

  def show
    @profile = User.find(user_params[:profile_id])
  end

  private

  def user_params
    params.permit(:profile_id)
  end
end

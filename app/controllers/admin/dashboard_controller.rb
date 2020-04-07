class Admin::DashboardController < ApplicationController

  def require_admin
    render file: "/public/404" unless current_admin?
  end
end

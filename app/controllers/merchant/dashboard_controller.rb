class Merchant::DashboardController < ApplicationController

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end
end

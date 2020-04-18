require 'rails_helper'

RSpec.describe "As a merchant employee: " do
  before(:each) do
    @bike_shop = create :merchant
    @employee = create :merchant_user
    visit "/login"

    fill_in :email, with: @employee.email
    fill_in :password, with: "123456"

    click_button "Login"
  end

  describe "When I visit the Merchant Dashboard I can " do
    it "visit my bulk discounts page" do
      click_link "Manage Bulk Discounts"

      expect(current_path).to eq("/merchant/discounts")
    end
  end
end

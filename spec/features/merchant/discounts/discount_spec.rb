require 'rails_helper'

RSpec.describe "As a merchant employee: " do
  before(:each) do
    @bike_shop = create :merchant
    @employee = User.create(name: "Mike Dao",
               street_address: "1765 Larimer St",
               city: "Denver",
               state: "CO",
               zip: "80202",
               email: "mike@example.com",
               password: "123456",
               password_confirmation: "123456",
               role: 1,
               merchant_id: @bike_shop.id)
    @discount_1 = @bike_shop.discounts.create(discount: 5, items: 5)

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

    it "I can see all my bulk discounts on my index page" do
      click_link "Manage Bulk Discounts"
      save_and_open_page

      within "#discount_#{@discount_1.id}" do
        expect(page).to have_content("Discount ##{@discount_1.id}: #{@discount_1.discount}% on #{@discount_1.items} items.")
      end
    end
  end
end

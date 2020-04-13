require 'rails_helper'

RSpec.describe("Admin Merchants Index P age") do
  describe "As an admin when I visit the merchants index page " do
    before(:each) do
      @admin = User.create(name: "Javi",
                  street_address: "1111 Rails St.",
                  city: "Denver",
                  state: "CO",
                  zip: "80201",
                  email: "test@turing.com",
                  password: "123456",
                  role: 2)

      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @mike = Merchant.create(name: "Mike's Bike Shop", address: '125 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @cory = Merchant.create(name: "Cory's Bike Shop", address: '127 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    end

    it "I can disable merchants who are not yet disabled" do
      visit "/login"
      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password
      click_button "Login"
      visit "/admin/merchants"

      within "#merchant_#{@meg.id}" do
        expect(page).to have_button("Disable")
      end
      within "#merchant_#{@mike.id}" do
        expect(page).to have_button("Disable")
      end
      within "#merchant_#{@cory.id}" do
        expect(page).to have_button("Disable")
        click_button "Disable"
      end

      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("#{@cory.name}'s account has been disabled.")
      within "#merchant_#{@meg.id}" do
        expect(page).to have_button("Disable")
      end
      within "#merchant_#{@mike.id}" do
        expect(page).to have_button("Disable")
      end
      within "#merchant_#{@cory.id}" do
        expect(page).to_not have_button("Disable")
      end
    end
  end
end

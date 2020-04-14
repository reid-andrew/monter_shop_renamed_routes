require 'rails_helper'

RSpec.describe("Admin User Show Page") do
  describe "As an admin when I visit a user's show page " do
    before(:each) do
      @admin = User.create(name: "The Boss",
                 street_address: "1765 Larimer St",
                 city: "Denver",
                 state: "CO",
                 zip: "80202",
                 email: "admin@example.com",
                 password: "123456",
                 password_confirmation: "123456",
                 role: 2)
      @user = User.create(name: "Meg",
                 street_address: "123 Stang Ave",
                 city: "Hershey",
                 state: "PA",
                 zip: "17033",
                 email: "meg@example.com",
                 password: "123456",
                 role: 0)
    end

    it "I see a user's information without edit link" do
      visit "/login"
      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password
      click_button "Login"
      visit ("/admin/users/#{@user.id}")

      expect(page).to have_content(@user.street_address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)
      expect(page).to have_content(@user.email)
      expect(page).to_not have_link("Edit My Profile Data")
    end
  end
end

# As an admin user
# When I visit a user's profile page ("/admin/users/5")
# I see the same information the user would see themselves
# I do not see a link to edit their profile

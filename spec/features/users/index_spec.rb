require 'rails_helper'

RSpec.describe "test users index", type: :feature do
  before(:each) do

    @user = User.create(name: "Mike Dao",
                street_address: "1765 Larimer St",
                city: "Denver",
                state: "CO",
                zip: "80202",
                email: "test@turing.com",
                password_digest: "123456",
                role: 0)

     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

    it "shows links to home, all merchants, all items, profile, logout, and no links to login or register" do

      visit "/"

      expect(page).to have_link("All Merchants")
      expect(page).to have_link("All Items")
      expect(page).to have_link("Profile")
      expect(page).to have_link("Logout")

      expect(page).to_not have_link("Login")
      expect(page).to_not have_link("Register")
  end
end

# 0 - user
# 1 - merchant
# 2 - admin

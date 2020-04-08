# As a registered user, merchant, or admin
# When I visit the logout path
# I am redirected to the welcome / home page of the site
# And I see a flash message that indicates I am logged out
# Any items I had in my shopping cart are deleted

require 'rails_helper'

RSpec.describe "As a registered user, merchant, or admin" do
  before do
    @user = User.create(name: "Mike Dao",
                    street_address: "1765 Larimer St",
                    city: "Denver",
                    state: "CO",
                    zip: "80202",
                    email: "test@turing.com",
                    password: "123456",
                    password_confirmation: "123456",
                    role: 0)
    @merchant = User.create(name: "Mike Dao",
                street_address: "1765 Larimer St",
                city: "Denver",
                state: "CO",
                zip: "80202",
                email: "test1@turing.com",
                password: "123456",
                password_confirmation: "123456",
                role: 1)
    @admin = User.create(name: "Mike Dao",
                street_address: "1765 Larimer St",
                city: "Denver",
                state: "CO",
                zip: "80202",
                email: "test2@turing.com",
                password: "123456",
                password_confirmation: "123456",
                role: 2)

  end
  describe "When I visit /logout"
    it "I am redirected to home page and see flash message that I'm logged out" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/login"

      fill_in :email, with: "test@turing.com"
      fill_in :password, with: "123456"

      click_button "Login"
      expect(page).to have_current_path("/profile")

      expect(page).to have_link("Logout")

      expect(page).to have_current_path("/")
      # expect(page).to have_content("Successfully logged out!")

    end

end

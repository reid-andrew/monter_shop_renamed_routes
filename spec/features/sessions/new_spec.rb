require 'rails_helper'

RSpec.describe "As a visitor" do
  before do
    @user = User.create(name: "Mike Dao",
                    street_address: "1765 Larimer St",
                    city: "Denver",
                    state: "CO",
                    zip: "80202",
                    email: "test@turing.com",
                    password_digest: "123456",
                    role: 0)
    @merchant = User.create(name: "Mike Dao",
                street_address: "1765 Larimer St",
                city: "Denver",
                state: "CO",
                zip: "80202",
                email: "test1@turing.com",
                password_digest: "123456",
                role: 1)
    @admin = User.create(name: "Mike Dao",
                street_address: "1765 Larimer St",
                city: "Denver",
                state: "CO",
                zip: "80202",
                email: "test2@turing.com",
                password_digest: "123456",
                role: 2)
  end
  describe "When I visit /login"
    it "I see a field to enter email and password" do

      visit "/login"

      expect(page).to have_field(:email)
      expect(page).to have_field(:password)

    end
    it "If I am a regular user, I am redirected to my profile page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/login"

      fill_in :email, with: "test@turing.com"
      fill_in :password, with: "123456"

      click_button "Login"
      expect(page).to have_current_path("/profile")
      expect(page).to have_content("Welcome, #{@user.name}!")
    end
    it "If I am a merchant user, I am redirected to my merchant dashboard page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit "/login"

      fill_in :email, with: "test1@turing.com"
      fill_in :password, with: "123456"

      click_button "Login"
      expect(page).to have_current_path("/merchant")
      expect(page).to have_content("Welcome, #{@merchant.name}!")
    end
    it "If I am an admin user, I am redirected to my admin dashboard page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      visit "/login"

      fill_in :email, with: "test2@turing.com"
      fill_in :password, with: "123456"

      click_button "Login"
      expect(page).to have_current_path("/admin")
      expect(page).to have_content("Welcome, #{@admin.name}!")
    end
end
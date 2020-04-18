require 'rails_helper'

RSpec.describe "As a visitor" do
  before do
    @bike_shop = create :merchant
    @user = create :user_regular
    @merchant = create :user_merchant
    @admin = create :user_admin
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

      fill_in :email, with: "meg@example.com"
      fill_in :password, with: "123456"

      click_button "Login"
      expect(page).to have_current_path("/profile")
      expect(page).to have_content("Welcome, #{@user.name}!")
    end

    it "If I am a merchant user, I am redirected to my merchant dashboard page" do
      visit "/login"

      fill_in :email, with: "mike@example.com"
      fill_in :password, with: "123456"

      click_button "Login"
      expect(page).to have_current_path("/merchant")
      expect(page).to have_content("Welcome, #{@merchant.name}!")
    end

    it "If I am an admin user, I am redirected to my admin dashboard page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      visit "/login"

      fill_in :email, with: "cory@example.com"
      fill_in :password, with: "123456"

      click_button "Login"
      expect(page).to have_current_path("/admin")
      expect(page).to have_content("Welcome, #{@admin.name}!")
    end

    it "If I submit invalid credentials, I'm redirected and get an error message" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/login"

      fill_in :email, with: "testttt@turing.com"
      fill_in :password, with: "123456"

      click_button "Login"
      expect(page).to have_current_path("/login")
      expect(page).to have_content("Sorry, your credentials are bad.")
    end
  describe "When I visit /login when I'm already logged in"
    it "If I am a regular user, I am redirected to my profile page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/login"

      fill_in :email, with: "meg@example.com"
      fill_in :password, with: "123456"

      click_button "Login"

      visit "/login"
      expect(page).to have_current_path("/profile")
      expect(page).to have_content("I'm already logged in")
    end

    it "If I am a merchant user, I am redirected to my merchant dashboard page" do
      visit "/login"

      fill_in :email, with: "mike@example.com"
      fill_in :password, with: "123456"

      click_button "Login"

      visit "/login"

      expect(page).to have_current_path("/merchant")
      expect(page).to have_content("I'm already logged in")
    end

    it "If I am an admin user, I am redirected to my admin dashboard page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      visit "/login"

      fill_in :email, with: "cory@example.com"
      fill_in :password, with: "123456"

      click_button "Login"

      visit "/login"
      expect(page).to have_current_path("/admin")
      expect(page).to have_content("I'm already logged in")
    end
end

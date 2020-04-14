require 'rails_helper'

RSpec.describe "As a visitor" do
  before do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop",
                                 address: '123 Bike Rd.',
                                 city: 'Richmond',
                                 state: 'VA',
                                 zip: 23137,
                                 active: true)
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
                role: 1,
                merchant_id: @bike_shop.id)
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
    it "If I submit invalid email, I'm redirected and get an error message" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/login"

      fill_in :email, with: "testttt@turing.com"
      fill_in :password, with: "123456"

      click_button "Login"
      expect(page).to have_current_path("/login")
      expect(page).to have_content("Sorry, your credentials are bad.")
      expect(page).to have_content("Invalid email")
    end
    it "If I submit invalid password, I'm redirected and get an error message" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/login"

      fill_in :email, with: "test@turing.com"
      fill_in :password, with: "badpassword"

      click_button "Login"
      expect(page).to have_current_path("/login")
      expect(page).to have_content("Sorry, your credentials are bad.")
      expect(page).to have_content("Invalid password")
    end
  describe "When I visit /login when I'm already logged in"
    it " If I am a regular user, I am redirected to my profile page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/login"

      fill_in :email, with: "test@turing.com"
      fill_in :password, with: "123456"

      click_button "Login"

      visit "/login"
      expect(page).to have_current_path("/profile")
      expect(page).to have_content("I'm already logged in")
    end
    it "If I am a merchant user, I am redirected to my merchant dashboard page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit "/login"

      fill_in :email, with: "test1@turing.com"
      fill_in :password, with: "123456"

      click_button "Login"

      visit "/login"
      expect(page).to have_current_path("/merchant")
      expect(page).to have_content("I'm already logged in")
    end
    it "If I am an admin user, I am redirected to my admin dashboard page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      visit "/login"

      fill_in :email, with: "test2@turing.com"
      fill_in :password, with: "123456"

      click_button "Login"

      visit "/login"
      expect(page).to have_current_path("/admin")
      expect(page).to have_content("I'm already logged in")
    end
end

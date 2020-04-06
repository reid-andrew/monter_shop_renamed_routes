require 'rails_helper'

RSpec.describe 'User Registration', type: :feature do
  before(:each) do
      @user_1 = {  name: "Mike Dao",
                  street_address: "1765 Larimer St",
                  city: "Denver",
                  state: "CO",
                  zip: "80202",
                  email: "test@turing.com",
                  password: "123456",
                  password_confirmation: "123456"}
  end

  describe "Index Page - A user can" do
    it "register a new user" do
      visit "/register"

      fill_in :name, with: "Andy Alex Ana Javi"
      fill_in :street_address, with: "123 Main St."
      fill_in :city, with: "Denver"
      fill_in :state, with: "CO"
      fill_in :zip, with: "80210"
      fill_in :email, with: "aaaj@turing.io"
      fill_in :password_digest, with: "Turing!"
      fill_in :password_confirmation, with: "Turing!"
      click_button "Register"

      expect(page).to have_current_path("/profile")
      expect(page).to have_content("Welcome, Andy Alex Ana Javi! You are registered and logged in.")
      expect(User.count).to eq(1)
    end

    it "returns to reg page if info is incomplete" do
      visit "/register"

      fill_in :city, with: "Denver"
      fill_in :state, with: "CO"
      fill_in :zip, with: "80210"
      fill_in :email, with: "aaaj@turing.io"
      fill_in :password_digest, with: "Turing!"
      fill_in :password_confirmation, with: "Turing!"
      click_button "Register"

      expect(page).to have_current_path("/register")
      expect(page).to have_content("You are missing required fields.")
      expect(User.count).to eq(0)
    end
  end
end

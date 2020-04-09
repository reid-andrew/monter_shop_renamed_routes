require 'rails_helper'

RSpec.describe 'User Registration', type: :feature do
  before(:each) do
    @user = User.create(  name: "Mike Dao",
                street_address: "1765 Larimer St",
                city: "Denver",
                state: "CO",
                zip: "80202",
                email: "test@turing.com",
                password: "123456",
                password_confirmation: "123456",
                role: 0)
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
      fill_in :password, with: "Turing!"
      fill_in :password_confirmation, with: "Turing!"
      click_button "Register"

      expect(page).to have_current_path("/profile")
      expect(page).to have_content("Welcome, Andy Alex Ana Javi! You are registered and logged in.")
      expect(User.count).to eq(2)
    end

    it "returns to reg page if info is incomplete" do
      visit "/register"

      fill_in :city, with: "Denver"
      fill_in :state, with: "CO"
      fill_in :zip, with: "80210"
      fill_in :email, with: "aaaj@turing.io"
      fill_in :password, with: "Turing!"
      fill_in :password_confirmation, with: "Turing!"
      click_button "Register"

      expect(page).to have_current_path("/register")
      expect(page).to have_content("You are missing required fields.")
      expect(User.count).to eq(1)
    end

    it "returns to reg page if info is incomplete or email is invalid" do
      visit "/register"

      fill_in :name, with: "Andy Alex Ana Javi"
      fill_in :street_address, with: "123 Main St."
      fill_in :city, with: "Denver"
      fill_in :state, with: "CO"
      fill_in :zip, with: "80210"
      fill_in :email, with: "test@turing.com"
      fill_in :password, with: "Turing!"
      fill_in :password_confirmation, with: "Turing!"
      click_button "Register"

      expect(page).to have_current_path("/register")
      expect(find_field(:name).value).to eq 'Andy Alex Ana Javi'
      expect(find_field(:street_address).value).to eq '123 Main St.'
      expect(find_field(:city).value).to eq 'Denver'
      expect(find_field(:state).value).to eq 'CO'
      expect(find_field(:zip).value).to eq '80210'
    end
  end
end

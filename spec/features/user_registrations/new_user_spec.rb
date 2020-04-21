require 'rails_helper'

RSpec.describe 'User Registration', type: :feature do
  before(:each) do
    @user = create :user_regular
    visit "/register"
  end

  describe "Index Page - A user can" do
    it "register a new user" do
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
      fill_in :name, with: "Meg"
      fill_in :street_address, with: "123 Stang Ave"
      fill_in :city, with: "Hershey"
      fill_in :state, with: "PA"
      fill_in :zip, with: "17033"
      fill_in :email, with: "meg@example.com"
      fill_in :password, with: "123456"
      fill_in :password_confirmation, with: "123456"
      click_button "Register"

      expect(page).to have_current_path("/register")
      expect(find_field(:name).value).to eq 'Meg'
      expect(find_field(:street_address).value).to eq '123 Stang Ave'
      expect(find_field(:city).value).to eq 'Hershey'
      expect(find_field(:state).value).to eq 'PA'
      expect(find_field(:zip).value).to eq '17033'
    end
  end
end

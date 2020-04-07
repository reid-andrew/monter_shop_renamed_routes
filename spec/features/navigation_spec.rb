
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end
  end

    it "shows link to home, link to login, link to register" do

      visit '/items'

      expect(page).to have_link("Home")
      click_link "Home"
      expect(current_path).to eq("/")

      expect(page).to have_link("Login")
      click_link "Login"
      expect(current_path).to eq("/login")

      expect(page).to have_link("Register")
      click_link "Register"
      expect(current_path).to eq("/register")
    end
  end
# - a link to return to the welcome / home page of the application ("/")
# - a link to log in ("/login")
# - a link to the user registration page ("/register")

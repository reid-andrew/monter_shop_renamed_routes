require 'rails_helper'

RSpec.describe 'Site Navigation' do
  before(:each) do
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

    it "shows a 404 error if a visitor tries to visit user, admin, or merchant page" do
      visit "/merchant"
      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit "/admin"
      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit "/profile"
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end

    it "shows a 404 error if a user tries to visit admin or merchant page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/merchant"
      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit "/admin"
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end

    it "shows a 404 error if a merchant tries to visit admin page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit "/admin"
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end

    it "shows a 404 error if an admin tries to visit merchant or cart page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      visit "/merchant"
      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit "/cart"
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end

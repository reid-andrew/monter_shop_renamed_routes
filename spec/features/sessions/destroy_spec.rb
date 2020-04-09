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
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
  end
  describe "When I visit /logout as a user"
    it "I am redirected to home page and see flash message that I'm logged out" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/login"

      fill_in :email, with: "test@turing.com"
      fill_in :password, with: "123456"

      click_button "Login"
      expect(page).to have_current_path("/profile")

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"

      expect(page).to have_content("Cart: 2")

      visit "/logout"

      expect(page).to have_current_path("/")
      expect(page).to have_content("Successfully logged out!")
      expect(page).to have_content("Cart: 0")

    end

end

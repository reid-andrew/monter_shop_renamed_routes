require 'rails_helper'

RSpec.describe "test users index", type: :feature do
  before(:each) do

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

    it "shows links to home, all merchants, all items, profile, logout, and no links to login or register" do

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/"

      expect(page).to have_link("Home")
      expect(page).to have_link("Profile")
      expect(page).to have_link("All Items")
      expect(page).to have_link("All Merchants")
      expect(page).to have_link("Cart: 0")
      expect(page).to have_link("Logout")
      expect(page).to have_content("Logged in as #{@user.name}")

      expect(page).to_not have_link("Login")
      expect(page).to_not have_link("Register")

  end

    it "shows merchants same links as a regular user plus link to merchant dashboard" do

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit "/"

      expect(page).to have_link("Home")
      expect(page).to have_link("Profile")
      expect(page).to have_link("All Items")
      expect(page).to have_link("All Merchants")
      expect(page).to have_link("Merchant Dashboard")
      expect(page).to have_link("Cart: 0")
      expect(page).to have_link("Logout")
      expect(page).to have_content("Logged in as #{@user.name}")

      expect(page).to_not have_link("Login")
      expect(page).to_not have_link("Register")

  end

  it "shows admins same links as a regular user plus links to admin dashboard and all users page" do

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit "/"

    expect(page).to have_link("Home")
    expect(page).to have_link("Profile")
    expect(page).to have_link("All Items")
    expect(page).to have_link("All Merchants")
    expect(page).to have_link("All Users")
    expect(page).to have_link("Admin Dashboard")
    expect(page).to have_link("Logout")
    expect(page).to have_content("Logged in as #{@user.name}")

    expect(page).to_not have_link("Cart: 0")
    expect(page).to_not have_link("Login")
    expect(page).to_not have_link("Register")

  end
end

require 'rails_helper'

RSpec.describe("Admin Users Index Page") do
  describe "As an admin when I visit the users index page " do
    before(:each) do
      @admin = User.create(name: "The Boss",
                 street_address: "1765 Larimer St",
                 city: "Denver",
                 state: "CO",
                 zip: "80202",
                 email: "admin@example.com",
                 password: "123456",
                 password_confirmation: "123456",
                 role: 2)
      @user1 = User.create(name: "Meg",
                 street_address: "123 Stang Ave",
                 city: "Hershey",
                 state: "PA",
                 zip: "17033",
                 email: "meg@example.com",
                 password: "123456",
                 role: 0)
     @user2 = User.create(name: "Andy",
                street_address: "123 Stang Ave",
                city: "Hershey",
                state: "PA",
                zip: "17033",
                email: "andy@example.com",
                password: "78910",
                role: 0)
    end

    it "I can click on All Users in the nav bar and link to all user index page" do
      visit "/login"

      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password

      click_button "Login"
      click_link "All Users"

      expect(current_path).to eq("/admin/users")

      within "#user_#{@user1.id}" do
        expect(page).to have_link("#{@user1.name}")
        expect(page).to have_content(@user1.created_at.strftime("%m/%d/%Y"))
        expect(page).to have_content(@user1.role)
      end

      within "#user_#{@user2.id}" do
        expect(page).to have_link("#{@user2.name}")
        expect(page).to have_content(@user2.created_at.strftime("%m/%d/%Y"))
        expect(page).to have_content(@user2.role)
      end

      click_link "#{@user1.name}"
      expect(current_path).to eq("/admin/profile/#{@user1.id}")
    end
  end
end

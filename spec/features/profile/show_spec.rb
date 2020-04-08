require 'rails_helper'

RSpec.describe 'Profile', type: :feature do
  before(:each) do
    @user = User.create(name: "Mike Dao",
                street_address: "1765 Larimer St",
                city: "Denver",
                state: "CO",
                zip: "80202",
                email: "test@turing.com",
                password_digest: "123456",
                role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  describe 'as a registered user when I visit my profile page' do
    it "I see my profile information except password" do

      visit '/profile'

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.street_address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)
      expect(page).to have_content(@user.email)
      expect(page).to have_link("Edit My Profile Data")
    end
  end
end

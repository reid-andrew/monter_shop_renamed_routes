require 'rails_helper'

RSpec.describe 'As a merchant', type: :feature do
  describe 'when I visit merchant dashboard /merchant' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop",
                                   address: '123 Bike Rd.',
                                   city: 'Richmond',
                                   state: 'VA',
                                   zip: 23137)
      @employee = User.create(name: "Mike Dao",
                 street_address: "1765 Larimer St",
                 city: "Denver",
                 state: "CO",
                 zip: "80202",
                 email: "test1@turing.com",
                 password: "123456",
                 password_confirmation: "123456",
                 role: 1,
                 merchant_id: @bike_shop.id)
      visit "/login"

      fill_in :email, with: "test1@turing.com"
      fill_in :password, with: "123456"

      click_button "Login"

    end
    it 'I see the name and full address of the merchant I work for' do

      visit "/merchant"

      expect(page).to have_content(@bike_shop.name)
      expect(page).to have_content(@bike_shop.address)
      expect(page).to have_content(@bike_shop.city)
      expect(page).to have_content(@bike_shop.state)
      expect(page).to have_content(@bike_shop.zip)

    end

  end
end

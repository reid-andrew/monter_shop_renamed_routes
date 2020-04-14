require 'rails_helper'

RSpec.describe "As a merchant employee" do
  before do
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
               email: "mike@example.com",
               password: "123456",
               password_confirmation: "123456",
               role: 1,
               merchant_id: @bike_shop.id)
    @user = User.create(name: "Meg",
               street_address: "123 Stang Ave",
               city: "Hershey",
               state: "PA",
               zip: "17033",
               email: "meg@example.com",
               password: "123456",
               role: 0)
    @tire = @bike_shop.items.create(name: "Bike Tire",
                            description: "They'll never pop!",
                            price: 200,
                            image: "https://mk0completetrid5cejy.kinstacdn.com/wp-content/uploads/2013-Shimano-Wheels-WH9000-C50-tubular-clincher.jpg",
                            inventory: 10)
    @helmet = @bike_shop.items.create(name: "Bike Helmet",
                            description: "They'll never crack!",
                            price: 100,
                            image: "https://cdn.shopify.com/s/files/1/0836/6919/products/vintage_bike_helmet_001_2000x.jpg?v=1585087482",
                            inventory: 12)
    @order_1 = Order.create(name: 'Meg',
                            address: '123 Stang Ave',
                            city: 'Hershey',
                            state: 'PA',
                            zip: "17033",
                            user: @user)
    @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

    visit "/login"

    fill_in :email, with: @employee.email
    fill_in :password, with: "123456"

    click_button "Login"
    visit "/merchant/items"
  end
  # User Story 44, Merchant deletes an item
  describe "When I visit my items page /merchant/items"
    it "I see a button to delete next to an item that has never been ordered" do

      within("#item-#{@helmet.id}") do
        expect(page).to have_button "Delete Item"
      end

    end
    it "I can delete an item, which returns me to my items page with a message
        and I no longer see the item on the page" do

        within("#item-#{@helmet.id}") do
          click_button "Delete Item"
        end

        expect(current_path).to eq("/merchant/items")

        within(".success-flash") do
          expect(page).to have_content("#{@helmet.name} is now deleted")
        end

        within(".items") do
          expect(page).to have_no_content(@helmet.name)
          expect(page).to have_no_content(@helmet.description)
        end
    end

end
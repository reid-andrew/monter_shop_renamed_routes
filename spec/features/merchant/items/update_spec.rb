require 'rails_helper'

RSpec.describe "As a merchant employee" do
  before do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop",
                                 address: '123 Bike Rd.',
                                 city: 'Richmond',
                                 state: 'VA',
                                 zip: 23137)
    @clothing_store = Merchant.create(name: "Clothing Store",
                                address: '123 Shirt Rd.',
                                city: 'Houston',
                                state: 'TX',
                                zip: 80802)

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
    @shirt = @clothing_store.items.create(name: "Red T-Shirt",
                            description: "Super soft",
                            price: 100,
                            image: "https://cdn.shopify.com/s/files/1/0836/6919/products/vintage_bike_helmet_001_2000x.jpg?v=1585087482",
                            inventory: 1)
    @order_1 = Order.create(name: 'Meg',
                            address: '123 Stang Ave',
                            city: 'Hershey',
                            state: 'PA',
                            zip: "17033",
                            user: @user)

    @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    @order_1.item_orders.create!(item: @helmet, price: @helmet.price, quantity: 3)
    @order_1.item_orders.create!(item: @shirt, price: @shirt.price, quantity: 1)

    visit "/login"

    fill_in :email, with: @employee.email
    fill_in :password, with: "123456"

    click_button "Login"
    visit "/merchant/items"
  end

  describe "When I visit my items page /merchant/items"
    it "I see the following: name, description, price, image, status, inventory" do
      within("#item-#{@tire.id}") do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content(@tire.price)
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content(@tire.inventory)
      end

      within("#item-#{@helmet.id}") do
        expect(page).to have_content(@helmet.name)
        expect(page).to have_content(@helmet.description)
        expect(page).to have_content(@helmet.price)
        expect(page).to have_css("img[src*='#{@helmet.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content(@helmet.inventory)
      end
    end

    it "I see a link to deactivate the item next to each active item" do
      within("#item-#{@tire.id}") do
        expect(page).to have_button "Deactivate Item"
      end

      within("#item-#{@helmet.id}") do
        expect(page).to have_button "Deactivate Item"
      end
    end

    it "I can deactivate an item by clicking a link next to the item" do
      within("#item-#{@tire.id}") do
        click_button "Deactivate Item"
      end

      expect(current_path).to eq("/merchant/items")

      within(".success-flash") do
        expect(page).to have_content("#{@tire.name} is no longer for sale")
      end
      within("#item-#{@tire.id}") do
        expect(page).to have_content("Inactive")
      end
    end

    it "I see a link to activate the item next to each active item" do
      within("#item-#{@tire.id}") do
        click_button "Deactivate Item"
      end

      within("#item-#{@tire.id}") do
        expect(page).to have_button "Activate Item"
      end
    end

    it "I can activate an item by clicking a link next to the item" do
      within("#item-#{@tire.id}") do
        click_button "Deactivate Item"
      end

      within("#item-#{@tire.id}") do
        click_button "Activate Item"
      end

      expect(current_path).to eq("/merchant/items")

      within(".success-flash") do
        expect(page).to have_content("#{@tire.name} is now available for sale")
      end
      within("#item-#{@tire.id}") do
        expect(page).to have_content("Active")
      end
    end
end

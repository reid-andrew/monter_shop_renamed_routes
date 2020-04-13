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
                            price: "200",
                            image: "https://mk0completetrid5cejy.kinstacdn.com/wp-content/uploads/2013-Shimano-Wheels-WH9000-C50-tubular-clincher.jpg",
                            inventory: "10")
    @helmet = @bike_shop.items.create(name: "Bike Helmet",
                            description: "They'll never crack!",
                            price: "100",
                            image: "https://cdn.shopify.com/s/files/1/0836/6919/products/vintage_bike_helmet_001_2000x.jpg?v=1585087482",
                            inventory: "12")
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
  # User Story 47, Merchant edits an item
  describe "When I visit my items page /merchant/items"
    it "I can see an edit button next to any item" do
      within("#item-#{@tire.id}") do
        expect(page).to have_link "Edit Item"
      end
    end
    it "When click an edit button next to an item, I'm taken to a pre-populated form" do
      within("#item-#{@tire.id}") do
        click_link "Edit Item"
      end

      expect(current_path).to eq("/merchant/items/#{@tire.id}/edit")

      expect(find_field(:name).value).to eq(@tire.name)
      expect(find_field(:description).value).to eq @tire.description
      expect(find_field(:price).value).to eq "#{@tire.price}"
      expect(find_field(:image).value).to eq @tire.image
      expect(find_field(:inventory).value).to eq "#{@tire.inventory}"

    end
    it "When I submit the form, I'm taken back to merchant/items and I see a full_message
        indicating my item is updated. I also see the item's new information" do
      # - name and description cannot be blank
      # - price cannot be less than $0.00
      # - inventory must be 0 or greater

      within("#item-#{@tire.id}") do
        click_link "Edit Item"
      end

      fill_in :name, with: ""
      fill_in :description, with: ""
      fill_in :image, with: ""
      fill_in :price, with: -18
      fill_in :inventory, with: -20

      click_button "Update Item"

      within(".error-flash") do
        expect(page).to have_content("Name can't be blank")
        expect(page).to have_content("Description can't be blank")
        expect(page).to have_content("Price must be greater than 0")
      end

      name =  "Javier's Specialty Goggles"
      description = "Goggles"
      price = 10
      inventory = 2

      fill_in :name, with: name
      fill_in :description, with: description
      fill_in :image, with: ""
      fill_in :price, with: price
      fill_in :inventory, with: inventory

      click_button "Update Item"

      within(".success-flash") do
        expect(page).to have_content("#{name} is updated")
      end

      within("#item-#{@tire.id}") do
        expect(page).to have_content(name)
        expect(page).to have_content(description)
        expect(page).to have_css("img[src*='https://semantic-ui.com/images/wireframe/image.png']")
        expect(page).to have_content(price)
        expect(page).to have_content(inventory)
        expect(page).to have_content("Active")
      end


    end


end
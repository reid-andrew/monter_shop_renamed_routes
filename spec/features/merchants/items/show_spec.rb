require 'rails_helper'

RSpec.describe "As a merchant employee, when I visit order showpage" do
  before do

    @bike_shop = Merchant.create(name: "Brian's Bike Shop",
                                 address: '123 Bike Rd.',
                                 city: 'Richmond',
                                 state: 'VA',
                                 zip: 23137,
                                 active: true)
    @clothing_store = Merchant.create(name: "Clothing Store",
                                address: '123 Shirt Rd.',
                                city: 'Houston',
                                state: 'TX',
                                zip: 80802,
                                active: true)
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
    visit "/merchant"
  end

  it "shows recipient's name and address, and do not see orders from other merchants" do

      click_link("View Order", href: "/merchant/orders/#{@order_1.id}")

      expect(page).to have_content("#{@user.name}")
      expect(page).to have_content("#{@user.address}")

      expect(page).to have_content("#{@tire.name}")
      expect(page).to have_content("#{@helmet.name}")
      expect(page).to_not have_content("#{@shirt.name}")
  end

  it "items show name as a link to item show page, image, price, and quantity desired" do

    click_link("View Order", href: "/merchant/orders/#{@order_1.id}")

    expect(page).to have_content("#{@tire.name}")
    expect(page).to have_css("img[src*='#{@tire.image}']")
    expect(page).to have_content("#{@tire.price}")
    expect(page).to have_content("2")

    expect(page).to have_content("#{@helmet.name}")
    expect(page).to have_css("img[src*='#{@helmet.image}']")
    expect(page).to have_content("#{@helmet.price}")
    expect(page).to have_content("3")
  end
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ItemOrder.destroy_all
Item.destroy_all
Order.destroy_all
Merchant.destroy_all

# Merchants
bike_shop = Merchant.create(name: "Brian's Bike Shop",
                             address: '123 Bike Rd.',
                             city: 'Richmond',
                             state: 'VA',
                             zip: 23137)
clothing_store = Merchant.create(name: "Clothing Store",
                            address: '123 Shirt Rd.',
                            city: 'Houston',
                            state: 'TX',
                            zip: 80802)

# Users
employee = User.create(name: "Mike Dao",
           street_address: "1765 Larimer St",
           city: "Denver",
           state: "CO",
           zip: "80202",
           email: "mike@example.com",
           password: "123456",
           password_confirmation: "123456",
           role: 1,
           merchant_id: bike_shop.id)
user = User.create(name: "Meg",
           street_address: "123 Stang Ave",
           city: "Hershey",
           state: "PA",
           zip: "17033",
           email: "meg@example.com",
           password: "123456",
           role: 0)

# Bike Store Items
tire = bike_shop.items.create(name: "Bike Tire",
                        description: "They'll never pop!",
                        price: 200,
                        image: "https://mk0completetrid5cejy.kinstacdn.com/wp-content/uploads/2013-Shimano-Wheels-WH9000-C50-tubular-clincher.jpg",
                        inventory: 10)
helmet = bike_shop.items.create(name: "Bike Helmet",
                        description: "They'll never crack!",
                        price: 100,
                        image: "https://cdn.shopify.com/s/files/1/0836/6919/products/vintage_bike_helmet_001_2000x.jpg?v=1585087482",
                        inventory: 12)

# Clothing Store Items
shirt = clothing_store.items.create(name: "Red T-Shirt",
                        description: "Super soft",
                        price: 100,
                        image: "https://cdn.shopify.com/s/files/1/0836/6919/products/vintage_bike_helmet_001_2000x.jpg?v=1585087482",
                        inventory: 1)

# Orders
order_1 = Order.create(name: 'Meg',
                        address: '123 Stang Ave',
                        city: 'Hershey',
                        state: 'PA',
                        zip: "17033",
                        user: user)
order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)
order_1.item_orders.create!(item: helmet, price: helmet.price, quantity: 3)
order_1.item_orders.create!(item: shirt, price: shirt.price, quantity: 1)


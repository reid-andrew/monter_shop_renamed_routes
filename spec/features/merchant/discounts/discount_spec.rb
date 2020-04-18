require 'rails_helper'

RSpec.describe "As a merchant employee" do
  before(:each) do
    @bike_shop = create :merchant
    @employee = create :merchant_user
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
  end
end

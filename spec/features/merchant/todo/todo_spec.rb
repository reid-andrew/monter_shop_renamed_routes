require 'rails_helper'

RSpec.describe "As a merchant " do
  before(:each) do
    @bike_shop = create :merchant
    @employee = create :user_merchant
    @employee.update(merchant_id: @bike_shop.id)
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
    @no_image_1 = @bike_shop.items.create(name: "Bike Shorts",
                            description: "They'll never look not creepy!",
                            price: 200,
                            image: "",
                            inventory: 10)
    @no_image_2 = @bike_shop.items.create(name: "Bike Seat",
                            description: "They'll never be comfortable!",
                            price: 100,
                            image: "",
                            inventory: 10)
    visit "/login"
    fill_in :email, with: @employee.email
    fill_in :password, with: "123456"
    click_button "Login"
  end

  it "I can see items using a placeholder image" do
    within "#to_do_list" do
      within "#placeholder_image_items" do
        expect(page).to have_link(@no_image_1.name)
        expect(page).to have_link(@no_image_2.name)
        expect(page).to_not have_link(@helmet.name)
      end
    end

    click_link "#{@no_image_1.name}"

    expect(page).to have_current_path("/items/#{@no_image_1.id}")

    @no_image_1.update(image: "https://cdn.shopify.com/s/files/1/0836/6919/products/vintage_bike_helmet_001_2000x.jpg?v=1585087482")
    @no_image_1.reload
    visit '/merchant'

    within "#to_do_list" do
      within "#placeholder_image_items" do
        expect(page).to_not have_link(@no_image_1.name)
        expect(page).to have_link(@no_image_2.name)
      end
    end
  end


end

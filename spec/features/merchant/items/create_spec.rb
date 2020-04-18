require 'rails_helper'

RSpec.describe "As a merchant employee" do
  before(:each) do
    @bike_shop = create :merchant
    @employee = create :user_merchant
    @user = create :user_regular

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

  describe "When I visit my items page /merchant/items"
    it "I see a link to add a new item" do
      expect(page).to have_link "Add New Item"
    end

    it "I can click the link to add a new item, which brings me to a form" do
      click_link "Add New Item"

      expect(current_path).to eq("/merchant/items/new")

      expect(page).to have_field :name
      expect(page).to have_field :description
      expect(page).to have_field :image
      expect(page).to have_field :price
      expect(page).to have_field :inventory

      click_button "Create Item"
    end

    it "I can submit the form with valid information, which creates a new item" do
      click_link "Add New Item"

      fill_in :name, with: "Bike Handles"
      fill_in :description, with: "Leather Grip"
      fill_in :image, with: ""
      fill_in :price, with: 18
      fill_in :inventory, with: 25

      click_button "Create Item"

      expect(current_path).to eq("/merchant/items")

      within(".success-flash") do
        expect(page).to have_content("Bike Handles is saved")
      end

      item = Item.all.last

      within("#item-#{item.id}") do
        expect(page).to have_content("Bike Handles")
        expect(page).to have_content("Leather Grip")
        expect(page).to have_css("img[src*='https://semantic-ui.com/images/wireframe/image.png']")
        expect(page).to have_content("18")
        expect(page).to have_content("25")
        expect(page).to have_content("Active")
      end
    end

    it "When I try to add a new item and any data is missing, I return to the form
        and see messages indicating the error. Fields are also re-populated" do

      click_link "Add New Item"

      fill_in :description, with: "Leather Grip"
      fill_in :image, with: ""
      fill_in :inventory, with: 25

      click_button "Create Item"

      within(".error-flash") do
        expect(page).to have_content("Name can't be blank")
        expect(page).to have_content("Price can't be blank")
      end

      expect(find_field(:name).value).to eq ""
      expect(find_field(:description).value).to eq "Leather Grip"
      expect(find_field(:price).value).to eq nil
      expect(find_field(:image).value).to eq nil
      expect(find_field(:inventory).value).to eq "25"
    end
end

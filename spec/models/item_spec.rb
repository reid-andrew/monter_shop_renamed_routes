require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "class methods" do
    before(:each) do
      @user = User.create(name: "Mike Dao",
                  street_address: "1765 Larimer St",
                  city: "Denver",
                  state: "CO",
                  zip: "80202",
                  email: "test@turing.com",
                  password: "123456",
                  role: 0)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @tire_2 = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy_2 = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @tire_3 = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy_3 = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @tire_4 = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy_4 = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @tire_5 = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy_5 = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @tire_6 = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy_6 = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @order_1 = Order.create(name: "Javi", address: "1111 Rails St.", city: "Denver", state: "CO", zip: "80201", user: @user)
      ItemOrder.create(order_id: @order_1.id, item_id: @tire_2.id, price: 1.99, quantity: 5004)
      ItemOrder.create(order_id: @order_1.id, item_id: @tire_3.id, price: 1.99, quantity: 5003)
      ItemOrder.create(order_id: @order_1.id, item_id: @tire_4.id, price: 1.99, quantity: 5002)
      ItemOrder.create(order_id: @order_1.id, item_id: @tire_5.id, price: 1.99, quantity: 5001)
      ItemOrder.create(order_id: @order_1.id, item_id: @tire_6.id, price: 1.99, quantity: 5000)
      ItemOrder.create(order_id: @order_1.id, item_id: @tire.id, price: 1.99, quantity: 200)
      ItemOrder.create(order_id: @order_1.id, item_id: @pull_toy.id, price: 1.99, quantity: 200)
      ItemOrder.create(order_id: @order_1.id, item_id: @pull_toy_2.id, price: 1.99, quantity: 5)
      ItemOrder.create(order_id: @order_1.id, item_id: @pull_toy_3.id, price: 1.99, quantity: 4)
      ItemOrder.create(order_id: @order_1.id, item_id: @pull_toy_4.id, price: 1.99, quantity: 3)
      ItemOrder.create(order_id: @order_1.id, item_id: @pull_toy_5.id, price: 1.99, quantity: 2)
      ItemOrder.create(order_id: @order_1.id, item_id: @pull_toy_6.id, price: 1.99, quantity: 1)
    end

    it ".active_items" do
      expect(Item.active_items.length).to eq(12)
      expect(Item.active_items[0]).to eq(@tire)
      expect(Item.active_items[11]).to eq(@pull_toy_6)
    end

    it ".top five items" do
      expect(Item.top_five_items.length).to eq(5)
      expect(Item.top_five_items[0]).to eq(@tire_2)
      expect(Item.top_five_items[1]).to eq(@tire_3)
      expect(Item.top_five_items[2]).to eq(@tire_4)
      expect(Item.top_five_items[3]).to eq(@tire_5)
      expect(Item.top_five_items[4]).to eq(@tire_6)
    end

    it ".bottom_five_items" do
      expect(Item.bottom_five_items.length).to eq(5)
      expect(Item.bottom_five_items[0]).to eq(@pull_toy_6)
      expect(Item.bottom_five_items[1]).to eq(@pull_toy_5)
      expect(Item.bottom_five_items[2]).to eq(@pull_toy_4)
      expect(Item.bottom_five_items[3]).to eq(@pull_toy_3)
      expect(Item.bottom_five_items[4]).to eq(@pull_toy_2)
    end
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @user = User.create(name: "Mike Dao",
                  street_address: "1765 Larimer St",
                  city: "Denver",
                  state: "CO",
                  zip: "80202",
                  email: "test@turing.com",
                  password: "123456",
                  role: 0)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "#order_count" do
      @order_1 = Order.create(name: "Javi", address: "1111 Rails St.", city: "Denver", state: "CO", zip: "80201", user: @user)
      ItemOrder.create(order_id: @order_1.id, item_id: @chain.id, price: 1.99, quantity: 5)

      expect(@chain.order_count).to eq(5)

      ItemOrder.create(order_id: @order_1.id, item_id: @chain.id, price: 1.99, quantity: 16)

      expect(@chain.order_count).to eq(21)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: @user)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it 'item#fulfillable?(num)' do
      expect(@chain.fulfillable?(51)).to eq(false)
      expect(@chain.fulfillable?(5)).to eq(true)
    end

    it 'item#item_order(order_id)' do
      @order_1 = Order.create(name: "Javi", address: "1111 Rails St.", city: "Denver", state: "CO", zip: "80201", user: @user)
      @item_order = ItemOrder.create(order_id: @order_1.id, item_id: @chain.id, price: 1.99, quantity: 5)

      expect(@chain.item_order(@order_1.id)).to eq(@item_order)
    end

    it 'item#fulfilled_inventory(order_id)' do
      @order_1 = Order.create(name: "Javi", address: "1111 Rails St.", city: "Denver", state: "CO", zip: "80201", user: @user)
      @item_order = ItemOrder.create(order_id: @order_1.id, item_id: @chain.id, price: 1.99, quantity: 4)

      expect(@chain.fulfilled_inventory(@order_1.id)).to eq(1)

      @order_2 = Order.create(name: "Javi", address: "1111 Rails St.", city: "Denver", state: "CO", zip: "80201", user: @user)
      @item_order = ItemOrder.create(order_id: @order_2.id, item_id: @chain.id, price: 1.99, quantity: 1)

      expect(@chain.fulfilled_inventory(@order_2.id)).to eq(0)
    end
  end
end

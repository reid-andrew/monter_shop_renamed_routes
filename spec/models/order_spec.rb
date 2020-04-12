require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :status }
  end

  describe "relationships" do
    it {should belong_to :user}
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
  end

  describe 'class methods' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @meg.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @meg.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      @user = User.create(name: "Javi",
                  street_address: "1111 Rails St.",
                  city: "Denver",
                  state: "CO",
                  zip: "80201",
                  email: "test@turing.com",
                  password: "123456",
                  role: 0)

# Pending Orders
      @order_1 = @user.orders.create(name: "Ana", address: "2222 Rails St.", city: "Denver", state: "CO", zip: "80201")
      @line_item_1 = ItemOrder.create(order_id: @order_1.id, item_id: @tire.id, price: 100, quantity: 4)

# Packaged Orders
      @order_2 = @user.orders.create(name: "Ana", address: "2222 Rails St.", city: "Denver", state: "CO", zip: "80201")
      @line_item_2 = ItemOrder.create(order_id: @order_2.id, item_id: @tire.id, price: 100, quantity: 4)
      @order_2.update(:status => "Packaged")

# Cancelled Orders
      @order_3 = @user.orders.create(name: "Ana", address: "2222 Rails St.", city: "Denver", state: "CO", zip: "80201")
      @line_item_3 = ItemOrder.create(order_id: @order_3.id, item_id: @tire.id, price: 100, quantity: 4)
      @order_3.update(:status => "Cancelled")

# Shipped Orders
      @order_4 = @user.orders.create(name: "Ana", address: "2222 Rails St.", city: "Denver", state: "CO", zip: "80201")
      @line_item_4 = ItemOrder.create(order_id: @order_4.id, item_id: @paper.id, price: 20, quantity: 500)
      @order_4.update(:status => "Shipped")
    end

    it '.orders_sorted_for_admin_display' do
      expect(Order.orders_sorted_for_admin_display).to eq([@order_2, @order_1, @order_4, @order_3])
    end
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @user = User.create(name: "Mike Dao",
                  street_address: "1765 Larimer St",
                  city: "Denver",
                  state: "CO",
                  zip: "80202",
                  email: "test@turing.com",
                  password: "123456",
                  role: 0)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: @user)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end

    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it 'total_quantity' do
      expect(@order_1.total_quantity).to eq(5)
    end


  end
end

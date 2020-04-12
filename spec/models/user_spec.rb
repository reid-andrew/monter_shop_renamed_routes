require 'rails_helper'

describe User, type: :model do
  describe "validations" do
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:name)}
    it { should validate_presence_of(:street_address)}
    it { should validate_presence_of(:city)}
    it { should validate_presence_of(:state)}
    it { should validate_presence_of(:zip)}
    it { should validate_presence_of(:email)}
    it { should validate_presence_of(:password)}
  end

  describe "relationships" do
    it {should have_many :orders}
  end

  describe 'model methods: ' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @user = User.create(name: "Javi",
                  street_address: "1111 Rails St.",
                  city: "Denver",
                  state: "CO",
                  zip: "80201",
                  email: "test@turing.com",
                  password: "123456",
                  role: 0)
      @order_1 = @user.orders.create(name: "Javi", address: "1111 Rails St.", city: "Denver", state: "CO", zip: "80201")
      ItemOrder.create(order_id: @order_1.id, item_id: @tire.id, price: 100, quantity: 4)
    end
    it "#order_count" do
      expect(@user.order_count).to eq(1)

      @order_2 = @user.orders.create(name: "Javi", address: "1111 Rails St.", city: "Denver", state: "CO", zip: "80201")
      ItemOrder.create(order_id: @order_2.id, item_id: @tire.id, price: 100, quantity: 4)

      expect(@user.order_count).to eq(2)
    end
  end
end

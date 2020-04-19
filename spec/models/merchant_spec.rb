require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :items}
  end

  describe 'instance methods: ' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @user = User.create(name: "Mike Dao",
                  street_address: "1765 Larimer St",
                  city: "Denver",
                  state: "CO",
                  zip: "80202",
                  email: "test@turing.com",
                  password: "123456",
                  role: 0)
    end

    it 'merchant#no_orders?' do
      expect(@meg.no_orders?).to eq(true)

      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: @user)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'merchant#item_count' do
      @meg.items.create(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.item_count).to eq(2)
    end

    it 'merchant#average_item_price' do
      @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.average_item_price).to eq(70)
    end

    it 'merchant#distinct_cities' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: @user)
      order_2 = Order.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033, user: @user)
      order_3 = Order.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033, user: @user)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities).to include("Denver")
      expect(@meg.distinct_cities).to include("Hershey")
    end

    it 'merchant#offer_discounts?' do
      expect(@meg.offers_discounts?).to eq(false)

      meg_discount = @meg.discounts.create(discount: 5, items: 5)
      expect(@meg.offers_discounts?).to eq(true)

      meg_discount.update(active: false)
      expect(@meg.offers_discounts?).to eq(false)
    end

    it 'merchant#minimum_for_discount' do
      @meg.discounts.create(discount: 5, items: 5)
      @meg.discounts.create(discount: 25, items: 25)

      expect(@meg.minimum_for_discount).to eq(5)
    end

    it 'merchant#applicable_discount' do
      @meg.discounts.create(discount: 5, items: 5)
      @meg.discounts.create(discount: 25, items: 25)

      expect(@meg.applicable_discount(5, 100)).to eq(5.0)
      expect(@meg.applicable_discount(6, 100)).to eq(5.0)
      expect(@meg.applicable_discount(24, 100)).to eq(5.0)
      expect(@meg.applicable_discount(25, 100)).to eq(25.0)
      expect(@meg.applicable_discount(35, 100)).to eq(25.0)
    end

    it 'merchant#discount_eligible' do
      @meg.discounts.create(discount: 5, items: 5)
      @meg.discounts.create(discount: 25, items: 25)

      expect(@meg.discount_eligible(4, 100)).to eq(0)
      expect(@meg.discount_eligible(5, 100)).to eq(5.0)
      expect(@meg.discount_eligible(25, 100)).to eq(25.0)
    end
  end
end

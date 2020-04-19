require 'rails_helper'

describe Discount, type: :model do
  describe 'instance methods: ' do
    before(:each) do
      @bike_shop = create :merchant
      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 100)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @discount_1 = @bike_shop.discounts.create(discount: 5, items: 5)
      @cart = Cart.new({@tire.id.to_s => 1})

    end
    it 'cart#initialize' do
      expect(@cart.contents).to eq({@tire.id.to_s => 1})
    end

    it 'cart#add_item' do
      @cart.add_item(@tire.id.to_s)
      expect(@cart.contents).to eq({@tire.id.to_s => 2})
      @cart.add_item(@tire.id.to_s)
      expect(@cart.contents).to eq({@tire.id.to_s => 3})
      @cart.add_item(@chain.id.to_s)
      expect(@cart.contents).to eq({@tire.id.to_s => 3, @chain.id.to_s => 1})
    end

    it 'cart#total_items' do
      expect(@cart.total_items).to eq(1)
      @cart.add_item(@tire.id.to_s)
      expect(@cart.total_items).to eq(2)
      @cart.add_item(@tire.id.to_s)
      expect(@cart.total_items).to eq(3)
      @cart.add_item(@chain.id.to_s)
      expect(@cart.total_items).to eq(4)
    end

    it 'cart#items' do
      expect(@cart.items).to eq({@tire => 1})
      @cart.add_item(@tire.id.to_s)
      expect(@cart.items).to eq({@tire => 2})
      @cart.add_item(@chain.id.to_s)
      expect(@cart.items).to eq({@tire => 2, @chain => 1})
    end

    it 'cart#subtotal' do
      expect(@cart.subtotal(@tire)).to eq(100)
      @cart.add_item(@tire.id.to_s)
      @cart.add_item(@tire.id.to_s)
      @cart.add_item(@tire.id.to_s)
      expect(@cart.subtotal(@tire)).to eq(400)
      @cart.add_item(@tire.id.to_s)
      expect(@cart.subtotal(@tire)).to eq(475)
    end

    it 'cart#total' do
      expect(@cart.total).to eq(100)
      @cart.add_item(@chain.id.to_s)
      expect(@cart.total).to eq(150)
      @cart.add_item(@tire.id.to_s)
      @cart.add_item(@tire.id.to_s)
      @cart.add_item(@tire.id.to_s)
      @cart.add_item(@tire.id.to_s)
      expect(@cart.total).to eq(525)
    end

    it 'cart#limit_reached?' do
      expect(@cart.limit_reached?(@chain.id.to_s)).to eq(false)
      @cart.add_item(@chain.id.to_s)
      @cart.add_item(@chain.id.to_s)
      @cart.add_item(@chain.id.to_s)
      @cart.add_item(@chain.id.to_s)
      expect(@cart.limit_reached?(@chain.id.to_s)).to eq(false)
      @cart.add_item(@chain.id.to_s)
      expect(@cart.limit_reached?(@chain.id.to_s)).to eq(true)
    end

    it 'cart#quantity_zero?' do
      expect(@cart.quantity_zero?(@tire.id.to_s)).to eq(false)
      @cart.subtract_quantity(@tire.id.to_s)
      expect(@cart.quantity_zero?(@tire.id.to_s)).to eq(true)
    end

    it 'cart#add_quantity' do
      expect(@cart.total_items).to eq(1)
      @cart.add_item(@chain.id.to_s)
      @cart.add_quantity(@chain.id.to_s)
      expect(@cart.total_items).to eq(3)
      @cart.add_quantity(@chain.id.to_s)
      @cart.add_quantity(@chain.id.to_s)
      @cart.add_quantity(@chain.id.to_s)
      expect(@cart.total_items).to eq(6)
      @cart.add_quantity(@chain.id.to_s)
      @cart.add_quantity(@chain.id.to_s)
      expect(@cart.total_items).to eq(6)
    end

    it 'cart#subtract_quantity' do
      expect(@cart.total_items).to eq(1)
      @cart.subtract_quantity(@tire.id.to_s)
      expect(@cart.total_items).to eq(0)
      @cart.subtract_quantity(@tire.id.to_s)
      @cart.subtract_quantity(@tire.id.to_s)
      expect(@cart.total_items).to eq(0)
    end

    it 'cart#discounted_item_in_cart' do
      expect(@cart.discounted_item_in_cart).to eq(false)
      @cart.add_quantity(@tire.id.to_s)
      @cart.add_quantity(@tire.id.to_s)
      @cart.add_quantity(@tire.id.to_s)
      expect(@cart.discounted_item_in_cart).to eq(false)
      @cart.add_quantity(@tire.id.to_s)
      expect(@cart.discounted_item_in_cart).to eq(true)
      @cart.subtract_quantity(@tire.id.to_s)
      expect(@cart.discounted_item_in_cart).to eq(false)
    end
  end
end

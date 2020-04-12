require 'rails_helper'

RSpec.describe("Orders") do
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
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @order_1 = @user.orders.create(name: "Javi", address: "1111 Rails St.", city: "Denver", state: "CO", zip: "80201")
    @line_item_1 = ItemOrder.create(order_id: @order_1.id, item_id: @tire.id, price: 100, quantity: 5)
    @line_item_2 = ItemOrder.create(order_id: @order_1.id, item_id: @paper.id, price: 20, quantity: 25)
    @line_item_3 = ItemOrder.create(order_id: @order_1.id, item_id: @pencil.id, price: 2, quantity: 50)
  end

  it "When merchants fulfill all items the order status updates" do
    expect(@order_1.status).to eq("Pending")
    expect(@line_item_1.status).to eq("Pending")
    expect(@line_item_2.status).to eq("Pending")
    expect(@line_item_3.status).to eq("Pending")


    visit "/item_order/#{@line_item_1.id}"
    click_on("Fulfill Order")
    @order_1.reload
    expect(@order_1.status).to eq("Pending")

    visit "/item_order/#{@line_item_2.id}"
    click_on("Fulfill Order")
    @order_1.reload
    expect(@order_1.status).to eq("Pending")

    visit "/item_order/#{@line_item_3.id}"
    click_on("Fulfill Order")
    @order_1.reload
    expect(@order_1.status).to eq("Packaged")
  end
end

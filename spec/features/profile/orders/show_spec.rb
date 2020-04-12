require 'rails_helper'

RSpec.describe 'User Order Show Page', type: :feature do
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
    @user2 = User.create(name: "Ana",
                street_address: "2222 Rails St.",
                city: "Denver",
                state: "CO",
                zip: "80201",
                email: "test_two@turing.com",
                password: "123456",
                role: 0)

    @order_1 = @user.orders.create(name: "Javi", address: "1111 Rails St.", city: "Denver", state: "CO", zip: "80201")
    @line_item_1 = ItemOrder.create(order_id: @order_1.id, item_id: @tire.id, price: 100, quantity: 4)
    @line_item_2 = ItemOrder.create(order_id: @order_1.id, item_id: @paper.id, price: 20, quantity: 500)
    @line_item_3 = ItemOrder.create(order_id: @order_1.id, item_id: @pencil.id, price: 2, quantity: 50)
  end
  describe "as a user when I " do
    it "visit my profile I see a link that takes me to my orders" do
      visit "/login"
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button "Login"
      visit "/profile"

      expect(page).to have_link("My Orders")

      click_link("My Orders")

      expect(current_path).to eq("/profile/orders")
    end

    it "visit visit my profile without having placed any orders I don't see the link" do
      visit "/login"
      fill_in :email, with: @user2.email
      fill_in :password, with: @user2.password
      click_button "Login"
      visit "/profile"

      expect(page).to_not have_link("My Orders")
    end

    it "sees correct details on orders show page" do
      visit "/login"
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button "Login"
      visit "/profile"

      expect(page).to have_link("My Orders")

      click_link("My Orders")

      expect(page).to have_content("Order #: #{@order_1.id}")
      expect(page).to have_content(@order_1.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_1.updated_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_1.status)
      expect(page).to have_content(@order_1.total_quantity)
      expect(page).to have_content(@order_1.grandtotal)
    end

    it "can click prior order id to see order show page" do
      visit "/login"
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button "Login"
      visit "/profile"

      expect(page).to have_link("My Orders")

      click_link("My Orders")
      click_link("Order #: #{@order_1.id}")

      expect(current_path).to eq("/profile/orders/#{@order_1.id}")
    end

    it "can see user profile orders show page with order details" do
      visit "/login"
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button "Login"
      visit "/profile"
      click_link("My Orders")
      click_link("Order #: #{@order_1.id}")

      expect(page).to have_content("Order #: #{@order_1.id}")
      expect(page).to have_content(@order_1.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_1.updated_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_1.status)
      expect(page).to have_content(@order_1.total_quantity)
      expect(page).to have_content(@order_1.grandtotal)
    end

    it "can see user profile orders show page with line item details" do
      visit "/login"
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button "Login"
      visit "/profile"
      click_link("My Orders")
      click_link("Order #: #{@order_1.id}")

      within "#item-#{@line_item_1.id}" do
        expect(page).to have_content(@line_item_1.item.name)
        expect(page).to have_content(@line_item_1.item.description)
        expect(page).to have_content(@line_item_1.quantity)
        expect(page).to have_content(@line_item_1.price)
        expect(page).to have_content(@line_item_1.subtotal)
        expect(page).to have_css("img[src*='#{@line_item_1.item.image}']")

      end

      within "#item-#{@line_item_3.id}" do
        expect(page).to have_content(@line_item_3.item.name)
        expect(page).to have_content(@line_item_3.item.description)
        expect(page).to have_content(@line_item_3.quantity)
        expect(page).to have_content(@line_item_3.price)
        expect(page).to have_content(@line_item_3.subtotal)
        expect(page).to have_css("img[src*='#{@line_item_3.item.image}']")
      end
    end

    it "can cancel an order" do
      visit "/login"
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button "Login"
      visit "/profile"
      click_link("My Orders")
      click_link("Order #: #{@order_1.id}")
      click_button("Cancel Order")

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Order ##{@order_1.id} has been canceled.")

      updated_order = Order.find(@order_1.id)
      updated_line_1 = ItemOrder.find(@line_item_1.id)
      updated_line_2 = ItemOrder.find(@line_item_2.id)
      updated_line_3 = ItemOrder.find(@line_item_3.id)

      expect(updated_order.status).to eq("Canceled")
      expect(updated_line_1.status).to eq("Unfulfilled")
      expect(updated_line_2.status).to eq("Unfulfilled")
      expect(updated_line_3.status).to eq("Unfulfilled")
    end

    it "cannot cancel and order that's been shipped" do
      @order_1.update(:status => "Shipped")
      visit "/login"
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button "Login"
      visit "/profile"
      click_link("My Orders")
      click_link("Order #: #{@order_1.id}")

      expect(page).to_not have_button("Cancel Order")
    end
  end
end

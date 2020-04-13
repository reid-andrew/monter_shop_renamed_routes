require 'rails_helper'

RSpec.describe("Admin Show Orders") do
  describe "As an admin when I visit the order show page " do
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
                  role: 2)
      @user2 = User.create(name: "Ana",
                  street_address: "2222 Rails St.",
                  city: "Denver",
                  state: "CO",
                  zip: "80201",
                  email: "test_two@turing.com",
                  password: "123456",
                  role: 0)

# Pending Orders
      @order_1 = @user2.orders.create(name: "Ana", address: "2222 Rails St.", city: "Denver", state: "CO", zip: "80201")
      @line_item_1 = ItemOrder.create(order_id: @order_1.id, item_id: @tire.id, price: 100, quantity: 4)
      @line_item_2 = ItemOrder.create(order_id: @order_1.id, item_id: @paper.id, price: 20, quantity: 500)

      @order_2 = @user2.orders.create(name: "Javi", address: "1111 Rails St.", city: "Denver", state: "CO", zip: "80201")
      @line_item_3 = ItemOrder.create(order_id: @order_2.id, item_id: @pencil.id, price: 2, quantity: 50)

# Packaged Orders
      @order_3 = @user2.orders.create(name: "Ana", address: "2222 Rails St.", city: "Denver", state: "CO", zip: "80201")
      @line_item_4 = ItemOrder.create(order_id: @order_3.id, item_id: @tire.id, price: 100, quantity: 4)
      @order_3.update(:status => "Packaged")

      @order_4 = @user2.orders.create(name: "Javi", address: "1111 Rails St.", city: "Denver", state: "CO", zip: "80201")
      @line_item_5 = ItemOrder.create(order_id: @order_4.id, item_id: @pencil.id, price: 2, quantity: 50)
      @order_4.update(:status => "Packaged")

# Cancelled Orders
      @order_5 = @user2.orders.create(name: "Ana", address: "2222 Rails St.", city: "Denver", state: "CO", zip: "80201")
      @line_item_6 = ItemOrder.create(order_id: @order_5.id, item_id: @tire.id, price: 100, quantity: 4)
      @order_5.update(:status => "Cancelled")

      @order_6 = @user2.orders.create(name: "Javi", address: "1111 Rails St.", city: "Denver", state: "CO", zip: "80201")
      @line_item_7 = ItemOrder.create(order_id: @order_6.id, item_id: @pencil.id, price: 2, quantity: 50)
      @order_6.update(:status => "Cancelled")

# Shipped Orders
      @order_7 = @user2.orders.create(name: "Ana", address: "2222 Rails St.", city: "Denver", state: "CO", zip: "80201")
      @line_item_8 = ItemOrder.create(order_id: @order_7.id, item_id: @paper.id, price: 20, quantity: 500)
      @order_7.update(:status => "Shipped")

      @order_8 = @user2.orders.create(name: "Javi", address: "1111 Rails St.", city: "Denver", state: "CO", zip: "80201")
      @line_item_9 = ItemOrder.create(order_id: @order_8.id, item_id: @pencil.id, price: 2, quantity: 50)
      @order_8.update(:status => "Shipped")
    end

    it "I can see info on all orders in the system" do
      visit "/login"
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button "Login"
      visit "/admin"

      within "#order_#{@order_1.id}" do
        expect(page).to have_link("#{@order_1.user.name}")
        expect(page).to have_content("#{@order_1.id}")
        expect(page).to have_content(@order_1.created_at.strftime("%m/%d/%Y"))
      end

      within "#order_#{@order_2.id}" do
        expect(page).to have_link("#{@order_2.user.name}")
        expect(page).to have_content("#{@order_2.id}")
        expect(page).to have_content(@order_2.created_at.strftime("%m/%d/%Y"))

        click_link("#{@order_2.user.name}")
        expect(current_path).to eq("/admin/profile/#{@order_2.user.id}")
      end
    end

    it "can see orders sorted correctly" do
      visit "/login"
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button "Login"
      visit "/admin"

      expect(page.text.index("#{@order_3.id}")).to be < page.text.index("#{@order_1.id}")
      expect(page.text.index("#{@order_4.id}")).to be < page.text.index("#{@order_2.id}")

      expect(page.text.index("#{@order_1.id}")).to be < page.text.index("#{@order_7.id}")
      expect(page.text.index("#{@order_2.id}")).to be < page.text.index("#{@order_8.id}")

      expect(page.text.index("#{@order_7.id}")).to be < page.text.index("#{@order_5.id}")
      expect(page.text.index("#{@order_8.id}")).to be < page.text.index("#{@order_6.id}")
    end

    it "can ship packaged orders" do
      visit "/login"
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button "Login"
      visit "/admin"

      within "#order_#{@order_3.id}" do
        expect(page).to have_content("Order Status: Packaged")
        click_button "Ship Order"
      end

      expect(current_path).to eq("/admin")
      expect(page.text.index("#{@order_1.id}")).to be < page.text.index("#{@order_3.id}")
      within "#order_#{@order_3.id}" do
        expect(page).to have_content("Order Status: Shipped")
        expect(page).to_not have_button("Ship Order")
      end
    end
  end
end

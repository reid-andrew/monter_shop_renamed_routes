require 'rails_helper'

RSpec.describe "As a User" do
  describe "When I purchase items with discounts applied " do
    before(:each) do
      @user = create :user_regular
      @bike_shop = create :merchant
      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 100)
      @discount_1 = @bike_shop.discounts.create(discount: 1, items: 5)
      @discount_2 = @bike_shop.discounts.create(discount: 5, items: 10)
      @discount_3 = @bike_shop.discounts.create(discount: 10, items: 25)

      visit "/login"
      fill_in :email, with: @user.email
      fill_in :password, with: "123456"
      click_button "Login"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
    end

    it "the discount doesn't show up until I buy enough" do
      visit "/cart"
      expect(page).to_not have_content("Discount")
      within "#cart-item-#{@tire.id}" do
        expect(page).to_not have_css("##{@tire.id}_discount")
        expect(page).to_not have_content("#{@discount_1.discount / 100.0 * @tire.price}")
        expect(page).to_not have_content("#{@discount_2.discount / 100.0 * @tire.price}")
        expect(page).to_not have_content("#{@discount_3.discount / 100.0 * @tire.price}")

        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"

        within "##{@tire.id}_discount" do
          expect(page).to have_content("#{@discount_1.discount / 100.0 * @tire.price}")
          expect(page).to_not have_content("#{@discount_2.discount / 100.0 * @tire.price}")
          expect(page).to_not have_content("#{@discount_3.discount / 100.0 * @tire.price}")
        end

        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"

        within "##{@tire.id}_discount" do
          expect(page).to_not have_content("#{@discount_1.discount / 100.0 * @tire.price}")
          expect(page).to have_content("#{@discount_2.discount / 100.0 * @tire.price}")
          expect(page).to_not have_content("#{@discount_3.discount / 100.0 * @tire.price}")
        end
      end
    end

    it "the total & subtotal of the order are updated" do
      visit "/cart"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"

      within "#cart-item-#{@tire.id}" do
        expect(page).to_not have_content("$1,200.00")
        expect(page).to have_content("$1,140.00")
      end

      expect(page).to_not have_content("Total: $1,200.00")
      expect(page).to have_content("Total: $1,140.00")
    end

    it "the discount shows up at checkout too" do
      visit "/cart"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_link "Checkout"
      expect(page).to have_content("Discount")
      expect(page).to_not have_content("Total: $1,200.00")
      expect(page).to have_content("Total: $1,140.00")
    end

    it "gets stored in item orders when the order is placed" do
      visit "/cart"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_link "Checkout"
      fill_in :name, with: "Mike Dao"
      fill_in :address, with: "1765 Larimer St"
      fill_in :city, with: "Denver"
      fill_in :state, with: "CO"
      fill_in :zip, with: "80202"
      click_button("Create Order")

      within "#order_#{Order.last.id}" do
        expect(page).to_not have_content("Order Grand Total: 1200.0")
        expect(page).to have_content("Order Grand Total: 1140.0")
        click_link "Order #: #{Order.last.id}"
      end

      expect(page).to_not have_content("Order Grand Total: 1200.0")
      expect(page).to have_content("Order Grand Total: 1140.0")

      within "#item-#{ItemOrder.last.id}" do
        expect(page).to_not have_content("Price Per Item: $100.00")
        expect(page).to have_content("Price Per Item: $95.00")
        expect(page).to_not have_content("Subtotal: $1,200.00")
        expect(page).to have_content("Subtotal: $1,140.00")
      end
    end

    it "doesn't apply deactivated discounts" do
      @discount_1.update(active: false)
      @discount_2.update(active: false)
      @discount_3.update(active: false)

      visit "/cart"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      expect(page).to_not have_content("Discount")
      within "#cart-item-#{@tire.id}" do
        expect(page).to_not have_css("##{@tire.id}_discount")
        expect(page).to_not have_content("#{@discount_1.discount / 100.0 * @tire.price}")
        expect(page).to_not have_content("#{@discount_2.discount / 100.0 * @tire.price}")
        expect(page).to_not have_content("#{@discount_3.discount / 100.0 * @tire.price}")
      end
    end
  end
end

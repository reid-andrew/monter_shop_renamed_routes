require 'rails_helper'

RSpec.describe "As a User" do
  describe "When I purchase items with discounts applied " do
    before(:each) do
      @bike_shop = create :merchant
      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 100)
      @discount_1 = @bike_shop.discounts.create(discount: 5, items: 10)
      @user = create :user_regular

      visit "/login"
      fill_in :email, with: @user.email
      fill_in :password, with: "123456"
      click_button "Login"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
    end

    it "doesn't show up until I buy enough" do
      visit "/cart"
      click_on "Checkout"

      within "#discounts" do
        expect(page).to_not have_content("Discount: 5%")
      end

      within "#cart-item-#{@tire.id}" do
        click_button "+"
        click_button "+"
        click_button "+"
      end

      within "#discounts" do
        expect(page).to_not have_content("Discount: #{@discount_1.discount}% for buying #{@discount_1.items} of #{@tire.name}")
      end

      within "#cart-item-#{@tire.id}" do
        click_button "+"
      end

      within "#discounts" do
        expect(page).to have_content("Discount: #{@discount_1.discount}% for buying #{@discount_1.items} of #{@tire.name}")
      end
    end
  end
end

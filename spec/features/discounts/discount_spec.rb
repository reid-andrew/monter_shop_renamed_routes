require 'rails_helper'

RSpec.describe "As a User" do
  describe "When I purchase items with discounts applied " do
    before(:each) do
      @user = create :user_regular
      @bike_shop = create :merchant
      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 100)
      @discount_0 = @bike_shop.discounts.create(discount: 15, items: 50)
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

    it "doesn't show up until I buy enough" do
      visit "/cart"
      within "#cart-item-#{@tire.id}" do
        within "##{@tire.id}_discount" do
          expect(page).to_not have_content("#{@discount_1.discount / 100.0 * @tire.price}")
          expect(page).to_not have_content("#{@discount_2.discount / 100.0 * @tire.price}")
          expect(page).to_not have_content("#{@discount_3.discount / 100.0 * @tire.price}")
          expect(page).to_not have_content("#{@discount_0.discount / 100.0 * @tire.price}")
        end

        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"

        within "##{@tire.id}_discount" do
          expect(page).to have_content("#{@discount_1.discount / 100.0 * @tire.price}")
          expect(page).to_not have_content("#{@discount_2.discount / 100.0 * @tire.price}")
          expect(page).to_not have_content("#{@discount_3.discount / 100.0 * @tire.price}")
          expect(page).to_not have_content("#{@discount_0.discount / 100.0 * @tire.price}")
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
          expect(page).to_not have_content("#{@discount_0.discount / 100.0 * @tire.price}")
        end
      end
    end
  end
end

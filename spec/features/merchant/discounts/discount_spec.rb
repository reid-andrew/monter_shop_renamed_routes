require 'rails_helper'

RSpec.describe "As a merchant employee: " do
  before(:each) do
    @bike_shop = create :merchant
    @employee = User.create(name: "Mike Dao",
               street_address: "1765 Larimer St",
               city: "Denver",
               state: "CO",
               zip: "80202",
               email: "mike@example.com",
               password: "123456",
               password_confirmation: "123456",
               role: 1,
               merchant_id: @bike_shop.id)
    @discount_1 = @bike_shop.discounts.create(discount: 5, items: 5)

    visit "/login"

    fill_in :email, with: @employee.email
    fill_in :password, with: "123456"

    click_button "Login"
  end

  describe "When I visit the Merchant Dashboard I can " do
    it "visit my bulk discounts page" do
      click_link "Manage Bulk Discounts"

      expect(current_path).to eq("/merchant/discounts")
    end

    it "I can see all my bulk discounts on my index page" do
      click_link "Manage Bulk Discounts"

      within "#discount_#{@discount_1.id}" do
        expect(page).to have_content("#{@discount_1.discount}% on #{@discount_1.items} items.")
      end
    end

    it "can create a new bulk discount" do
      click_link "Manage Bulk Discounts"
      click_link "Create New Bulk Discount"

      expect(current_path).to eq("/merchant/discounts/new")
      fill_in :discount, with: 10
      fill_in :items, with: 10
      click_button "Save"

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("You have created a new bulk discount.")

      new_disc = Discount.last
      within "#discount_#{new_disc.id}" do
        expect(page).to have_content("#{new_disc.discount}% on #{new_disc.items} items.")
      end
    end

    it "can view and edit an existing bulk discount" do
      click_link "Manage Bulk Discounts"
      within "#discount_#{@discount_1.id}" do
        click_link "View Discount"
      end

      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}")
      expect(page).to have_content("Discount of #{@discount_1.discount}% on #{@discount_1.items} items.")

      click_link "Edit Discount"

      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")

      fill_in :discount, with: 25
      fill_in :items, with: 25
      click_button "Save"

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("You have updated an existing bulk discount.")

      @discount_1.reload
      within "#discount_#{@discount_1.id}" do
        expect(page).to have_content("#{@discount_1.discount}% on #{@discount_1.items} items.")
        expect(page).to have_content("25% on 25 items.")
      end
    end

    it "can delete a discount" do
      click_link "Manage Bulk Discounts"
      within "#discount_#{@discount_1.id}" do
        click_link "View Discount"
      end
      click_link "Delete Discount"

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("You have deleted an existing bulk discount.")
      expect(page).to_not have_content("#{@discount_1.discount}% on #{@discount_1.items} items.")
    end
  end
end

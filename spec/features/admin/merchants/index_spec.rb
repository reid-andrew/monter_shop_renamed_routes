require 'rails_helper'

RSpec.describe("Admin Merchants Index Page") do
  describe "As an admin when I visit the merchants index page " do
    before(:each) do
      @admin = User.create(name: "Javi",
                  street_address: "1111 Rails St.",
                  city: "Denver",
                  state: "CO",
                  zip: "80201",
                  email: "test@turing.com",
                  password: "123456",
                  role: 2)

      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @mike = Merchant.create(name: "Mike's Bike Shop", address: '125 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @cory = Merchant.create(name: "Cory's Bike Shop", address: '127 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @meg.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @meg.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    end

    it "I can disable merchants who are not yet disabled" do
      visit "/login"
      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password
      click_button "Login"
      visit "/admin/merchants"

      within "#merchant_#{@meg.id}" do
        expect(page).to have_button("Disable")
      end
      within "#merchant_#{@mike.id}" do
        expect(page).to have_button("Disable")
      end
      within "#merchant_#{@cory.id}" do
        expect(page).to have_button("Disable")
        click_button "Disable"
      end

      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("#{@cory.name}'s account has been disabled.")
      within "#merchant_#{@meg.id}" do
        expect(page).to have_button("Disable")
      end
      within "#merchant_#{@mike.id}" do
        expect(page).to have_button("Disable")
      end
      within "#merchant_#{@cory.id}" do
        expect(page).to_not have_button("Disable")
        expect(page).to have_button("Enable")
      end
    end

    it "I can disable all merchant items when I disable the merchant" do
      visit "/login"
      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password
      click_button "Login"
      visit "/admin/merchants"

      expect(@tire.active?).to eq(true)
      expect(@paper.active?).to eq(true)
      expect(@pencil.active?).to eq(true)

      within "#merchant_#{@meg.id}" do
        click_button "Disable"
      end

      @tire.reload
      @paper.reload
      @pencil.reload

      expect(@tire.active?).to eq(false)
      expect(@paper.active?).to eq(false)
      expect(@pencil.active?).to eq(false)
    end

    it "I can enable a disabled merchant" do
      visit "/login"
      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password
      click_button "Login"
      @cory.update(:active => false)
      visit "/admin/merchants"

      within "#merchant_#{@cory.id}" do
        expect(page).to have_button("Enable")
        click_button "Enable"
      end
      expect(current_path).to eq("/admin/merchants")

      @cory.reload
      expect(@cory.active).to eq(true)

      expect(page).to have_content("#{@cory.name}'s account has been enabled.")
      expect(page).to_not have_button("Enable")
      expect(page).to have_button("Disable")
    end

    it "I can enable an enabled merhant's items" do
      visit "/login"
      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password
      click_button "Login"
      visit "/admin/merchants"

      within "#merchant_#{@meg.id}" do
        click_button "Disable"
      end

      @tire.reload
      @paper.reload
      @pencil.reload

      expect(@tire.active?).to eq(false)
      expect(@paper.active?).to eq(false)
      expect(@pencil.active?).to eq(false)

      within "#merchant_#{@meg.id}" do
        click_button "Enable"
      end

      @tire.reload
      @paper.reload
      @pencil.reload

      expect(@tire.active?).to eq(true)
      expect(@paper.active?).to eq(true)
      expect(@pencil.active?).to eq(true)
    end

    it "I see all merchants in the system as links to their show pages" do
      visit "/login"
      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password
      click_button "Login"
      visit "/admin/merchants"

      within "#merchant_#{@cory.id}" do
        expect(page).to have_link("#{@cory.name}")
        expect(page).to have_content("#{@cory.city}")
        expect(page).to have_content("#{@cory.state}")
      end

      within "#merchant_#{@meg.id}" do
        expect(page).to have_link("#{@meg.name}")
        expect(page).to have_content("#{@meg.city}")
        expect(page).to have_content("#{@meg.state}")
      end

      click_link "#{@cory.name}"
      expect(current_path).to eq("/admin/merchants/#{@cory.id}")
    end
  end
end

require 'rails_helper'

describe Discount, type: :model do
  describe "validations" do
    it { should validate_presence_of :discount }
    it { should validate_presence_of :items }
  end

  describe "relationships" do
    it {should belong_to :merchant}
  end

  describe "class methods: " do
    it "discount.set_defaults" do
      bike_shop = create :merchant
      discount = bike_shop.discounts.create(discount: 5, items: 5)
      expect(discount.active).to eq(true)
    end
  end

end

class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :orders, through: :item_orders
  has_many :discounts, dependent: :destroy

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def offers_discounts?
    discounts.where("active = true") == [] ? false : true
  end

  def minimum_for_discount
    discounts.minimum(:items)
  end

  def applicable_discount(quantity, price)
    discount_to_apply = discounts.select("discounts.*").where("items <= ?", quantity).order("items DESC").limit(1)
    discount_to_apply.first.discount / 100.0 * price
  end

  def discount_eligible(quantity, price)
    if offers_discounts? && quantity >= minimum_for_discount
      applicable_discount(quantity, price)
    else
      0
    end
  end
end

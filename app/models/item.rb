class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0

  def self.active_items
    Item.where(active?:true)
  end

  def self.top_five_items
    # require "pry"; binding.pry
    Item.select("items.id, items.name, count(item_orders.id) as io_count")
    .left_joins(:item_orders)
    .group(:id, :name)
    .order(count: :desc)
    .limit(5)
  end

  def order_count

  end

  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end
end

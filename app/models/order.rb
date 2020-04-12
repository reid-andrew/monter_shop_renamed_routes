class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :status

  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_quantity
    item_orders.sum('quantity')
  end

  def total_quantity_by_merchant(merchant_id)
    merchant_items = items.select(:id).where(:merchant_id => merchant_id)
    ItemOrder.where(:item_id => merchant_items).sum(:quantity)
  end

  def total_value_by_merchant(merchant_id)
    merchant_items = items.select(:id).where(:merchant_id => merchant_id)
    ItemOrder.where(:item_id => merchant_items).sum('price * quantity').to_i
  end

end

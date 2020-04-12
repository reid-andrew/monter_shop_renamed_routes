class User < ApplicationRecord
  validates_presence_of :name, :street_address, :city, :state, :zip, :email
  validates_presence_of :password, on: :create
  validates :email, uniqueness: true

  enum role: %w(user merchant admin)

  has_secure_password

  has_many :orders

  def order_count
    orders.count
  end
end

class User < ApplicationRecord
  validates_presence_of :name, :street_address, :city, :state, :zip, :email, :password_digest
  validates :email, uniqueness: true

  enum role: %w(user merchant admin)

  has_secure_password

end

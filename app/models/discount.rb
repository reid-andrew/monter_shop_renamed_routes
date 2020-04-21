class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :discount,
                        :items

  before_create :set_defaults

  def set_defaults
    self.active = true
  end
end

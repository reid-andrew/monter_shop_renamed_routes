class CreateDiscount < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.integer :discount
      t.integer :items
      t.references :merchant, foreign_key: true
      t.boolean :active
      t.timestamps
    end
  end
end

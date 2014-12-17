class CreateProductOrders < ActiveRecord::Migration
  def change
    create_table :product_orders do |t|
      t.integer :order_id
      t.integer :product_id
      t.integer :product_count
      t.string :unit_price

      t.timestamps
    end
  end
end

class CreateGroupOrders < ActiveRecord::Migration
  def change
    create_table :group_orders do |t|
      t.integer :order_id
      t.integer :group_id
      t.integer :group_count
      t.string :unit_price

      t.timestamps
    end
  end
end

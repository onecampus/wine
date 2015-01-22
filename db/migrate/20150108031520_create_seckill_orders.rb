class CreateSeckillOrders < ActiveRecord::Migration
  def change
    create_table :seckill_orders do |t|
      t.integer :order_id
      t.integer :seckill_id
      t.integer :seckill_count
      t.string :unit_price

      t.timestamps
    end
  end
end

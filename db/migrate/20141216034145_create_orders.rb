class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :invoice_id
      t.integer :user_id
      t.string :order_number
      t.string :ship_address
      t.string :ship_method
      t.string :payment_method
      t.string :freight
      t.string :package_charge
      t.string :total_price
      t.datetime :buy_date
      t.integer :order_status
      t.integer :pay_status
      t.integer :logistics_status
      t.integer :operator
      t.string :cancel_reason
      t.string :weixin_open_id
      t.string :receive_name
      t.string :mobile
      t.string :tel
      t.integer :supplier_id
      t.string :order_type

      t.timestamps
    end
  end
end

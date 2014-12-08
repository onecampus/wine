class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :price
      t.string :img
      t.integer :cat_id
      t.text :description
      t.string :brand
      t.datetime :expiration_date
      t.string :country
      t.string :package_type
      t.string :product_model
      t.integer :status
      t.string :profit
      t.string :vip_price
      t.integer :is_new
      t.integer :is_boutique
      t.string :unit

      t.timestamps
    end
  end
end

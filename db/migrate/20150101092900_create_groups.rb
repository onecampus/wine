class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :product_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer :limit_people_count
      t.integer :limit_product_count
      t.text :description
      t.string :price
      t.string :saveup
      t.string :discount
      t.integer :people

      t.timestamps
    end
  end
end

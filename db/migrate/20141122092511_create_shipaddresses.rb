class CreateShipaddresses < ActiveRecord::Migration
  def change
    create_table :shipaddresses do |t|
      t.integer :user_id
      t.string :receive_name
      t.string :province
      t.string :city
      t.string :region
      t.string :address
      t.string :postcode
      t.string :tel
      t.string :mobile

      t.timestamps
    end
  end
end

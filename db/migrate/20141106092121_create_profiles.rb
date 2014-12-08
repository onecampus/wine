class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.integer :is_locked
      t.integer :parent_id
      t.integer :supplier_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.string :mobile
      t.string :tel
      t.string :province
      t.string :city
      t.string :region
      t.string :address
      t.string :fax
      t.string :invite_code
      t.string :share_link_code
      t.integer :default_address_id
      t.string :weixin_open_id

      t.timestamps
    end
  end
end

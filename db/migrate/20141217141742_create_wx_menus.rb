class CreateWxMenus < ActiveRecord::Migration
  def change
    create_table :wx_menus do |t|
      t.string :name
      t.text :msg
      t.string :url
      t.integer :msg_or_url
      t.string :button_type
      t.string :key
      t.integer :parent_id
      t.integer :level

      t.timestamps
    end
  end
end

class CreateWxMenus < ActiveRecord::Migration
  def change
    create_table :wx_menus do |t|
      t.string :name
      t.integer :msg_or_url
      t.string :url
      t.string :title
      t.text :description
      t.string :img
      t.string :msg_type
      t.string :media_id
      t.string :button_type
      t.string :key
      t.integer :parent_id
      t.integer :level

      t.timestamps
    end
  end
end

class CreateCats < ActiveRecord::Migration
  def change
    create_table :cats do |t|
      t.string :title
      t.text :content
      t.text :secret_field
      t.string :name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth

      t.timestamps
    end
  end
end

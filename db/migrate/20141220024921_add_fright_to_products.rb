class AddFrightToProducts < ActiveRecord::Migration
  def change
    add_column :products, :fright, :string
  end
end

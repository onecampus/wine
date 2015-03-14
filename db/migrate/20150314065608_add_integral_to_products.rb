class AddIntegralToProducts < ActiveRecord::Migration
  def change
    add_column :products, :integral, :integer
  end
end

class AddIsCommissionToProducts < ActiveRecord::Migration
  def change
    add_column :products, :is_commission, :integer
  end
end

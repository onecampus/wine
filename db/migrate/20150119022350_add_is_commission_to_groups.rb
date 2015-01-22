class AddIsCommissionToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :is_commission, :integer
  end
end

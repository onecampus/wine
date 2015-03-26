class AddCommissionTypeToCommissions < ActiveRecord::Migration
  def change
    add_column :commissions, :commission_type, :string
  end
end

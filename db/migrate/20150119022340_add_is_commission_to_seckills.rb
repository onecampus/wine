class AddIsCommissionToSeckills < ActiveRecord::Migration
  def change
    add_column :seckills, :is_commission, :integer
  end
end

class AddFromUserIdToCommissions < ActiveRecord::Migration
  def change
    add_column :commissions, :from_user_id, :integer
  end
end

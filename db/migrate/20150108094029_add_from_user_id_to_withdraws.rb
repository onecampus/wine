class AddFromUserIdToWithdraws < ActiveRecord::Migration
  def change
    add_column :withdraws, :from_user_id, :integer
  end
end

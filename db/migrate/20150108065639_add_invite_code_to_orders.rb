class AddInviteCodeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :invite_code, :string
  end
end

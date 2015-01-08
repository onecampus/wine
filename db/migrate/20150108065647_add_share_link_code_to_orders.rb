class AddShareLinkCodeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :share_link_code, :string
  end
end

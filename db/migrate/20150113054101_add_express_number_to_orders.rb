class AddExpressNumberToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :express_number, :string
  end
end

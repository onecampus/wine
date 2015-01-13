class AddExpressCompanyToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :express_company, :string
  end
end

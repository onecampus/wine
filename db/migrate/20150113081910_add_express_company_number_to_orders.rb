class AddExpressCompanyNumberToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :express_company_number, :string
  end
end

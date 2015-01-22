class AddDrawMoneyToWithdraws < ActiveRecord::Migration
  def change
    add_column :withdraws, :draw_money, :string
  end
end

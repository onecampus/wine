class AddCommissionScoreToCommissions < ActiveRecord::Migration
  def change
    add_column :commissions, :commission_score, :integer
  end
end

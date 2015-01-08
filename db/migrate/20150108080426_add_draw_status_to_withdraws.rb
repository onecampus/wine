class AddDrawStatusToWithdraws < ActiveRecord::Migration
  def change
    add_column :withdraws, :draw_status, :integer
  end
end

class AddRemainMarkToScores < ActiveRecord::Migration
  def change
    add_column :scores, :remain_mark, :integer
  end
end

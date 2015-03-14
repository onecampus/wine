class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :user_id
      t.string :mark

      t.timestamps
    end
  end
end

class CreateVritualcards < ActiveRecord::Migration
  def change
    create_table :vritualcards do |t|
      t.integer :user_id
      t.string :money

      t.timestamps
    end
  end
end

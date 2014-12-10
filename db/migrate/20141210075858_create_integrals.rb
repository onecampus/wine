class CreateIntegrals < ActiveRecord::Migration
  def change
    create_table :integrals do |t|
      t.integer :user_id
      t.string :amount

      t.timestamps
    end
  end
end

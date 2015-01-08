class CreateWithdraws < ActiveRecord::Migration
  def change
    create_table :withdraws do |t|
      t.integer :user_id
      t.string :bank_card
      t.string :alipay
      t.string :we_chat_payment
      t.string :draw_type

      t.timestamps
    end
  end
end

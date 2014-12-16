class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :rise
      t.text :content

      t.timestamps
    end
  end
end

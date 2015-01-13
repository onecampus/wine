class AddRemainToSeckills < ActiveRecord::Migration
  def change
    add_column :seckills, :remain, :integer
  end
end

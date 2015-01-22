class AddLimitPerPersonToSeckills < ActiveRecord::Migration
  def change
    add_column :seckills, :limit_per_person, :integer
  end
end

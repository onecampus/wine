class AddLimitPerPersonToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :limit_per_person, :integer
  end
end

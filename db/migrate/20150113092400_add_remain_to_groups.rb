class AddRemainToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :remain, :integer
  end
end

class CreateSiteConfigs < ActiveRecord::Migration
  def change
    create_table :site_configs do |t|
      t.string :key
      t.string :val
      t.string :img
      t.string :config_type

      t.timestamps
    end
  end
end

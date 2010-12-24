class CreateProjectConfigs < ActiveRecord::Migration
  def self.up
    create_table :project_configs do |t|
      t.string :name
      t.string :key

      t.timestamps
    end
  end

  def self.down
    drop_table :project_configs
  end
end

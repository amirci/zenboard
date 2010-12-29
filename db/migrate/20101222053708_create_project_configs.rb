class CreateProjectConfigs < ActiveRecord::Migration
  def self.up
    create_table :project_configs do |t|
      t.string  :name
      t.string  :key
      t.integer :user_id
      t.integer :project_id

      t.timestamps
    end
  end

  def self.down
    drop_table :project_configs
  end
end

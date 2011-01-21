class ProjectConfig < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :api_key, :name, :project_id
  validates_uniqueness_of :project_id, :scope => [:api_key, :user_id]
end

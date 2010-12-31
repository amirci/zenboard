class ProjectConfig < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :api_key, :name, :project_id
  
end

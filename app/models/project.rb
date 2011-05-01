require 'agilezen'
require 'json_date'

class Project < AgileZenResource
  include StoryMetrics
  
  def self.api_key=(key)
    self.headers["X-Zen-ApiKey"] = key
  end
  
  def self.api_key
    self.headers["X-Zen-ApiKey"]
  end

  # All stories associated to the project
  def stories
    @stories ||= Story.all_for_project(id, Project.api_key)
  end
  
  def each(&block)
    @stories.each(&block)
  end
  
  # Date when the project was created
  def created_on
    DateTime.parse(createTime)
  end

  def stories_with_tag(tag_id)
    stories.find_all { |s| !s.tags.nil? && s.tags.any? { |t| t.id.to_s == tag_id } } 
  end
  
  def tags
    stories.collect { |s| s.tags }.flatten.uniq { |t| t.id }.sort_by { |t| t.name }
  end
  
  def to_hash
    { "id" => id,
        "name" => name,
        "description" => description,
        "createTime" => createTime,
        "owner" => { "id" => owner.id, "name" => owner.name} }
  end
  
end

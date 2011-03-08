require 'agilezen'
require 'json_date'

class Project < AgileZenResource
  attr_reader :archived, :stories

  def self.api_key=(key)
    self.headers["X-Zen-ApiKey"] = key
  end
  
  def self.api_key
    self.headers["X-Zen-ApiKey"]
  end
  
  def self.switch_https(use_https)
    protocol = "http" 
    protocol += "s" if use_https
    self.site = "#{protocol}://agilezen.com/api/v1/"
  end

  # All stories associated to the project
  def load_stories
    @stories = Story.all_for_project(id, Project.api_key)
    @archived = @stories.find_all { |s| s.phase.name.include? 'Archive' }
    @stories
  end
  
  # Date when the project was created
  def created_on
    DateTime.parse(createTime)
  end

  # Returns the sum of the size for all the archived stories
  def velocity
    @archived ||= []
    @archived.sum { |s| s.size.to_i }
  end
  
  # Amount of stories in archive
  def throughput
    @archived ||= []
    @archived.count
  end
  
  # Amount of days per point using each story point duration
  def point_duration
    @archived ||= []
    @archived.sum { |s| s.point_duration.to_f } / @archived.count
  end
  
  def to_hash
    { "id" => id,
        "name" => name,
        "description" => description,
        "createTime" => createTime,
        "owner" => { "id" => owner.id, "name" => owner.name} }
  end
  
end

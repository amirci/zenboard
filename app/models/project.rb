require 'agilezen'
require 'json_date'

class Project < AgileZenResource
  attr_reader :archived
  self.headers["X-Zen-ApiKey"] = "f7ba5d7ea3254f31aa15d17e3d4e8ee1"

  # Date when the project was created
  def created_on
    JSONHelper::Date.from_json(createTime)
  end
  
  # All stories associated to the project
  def stories
    @stories = Story.all_for_project(id)
    @archived = @stories.find_all { |s| s.phase.name == 'Archive' }
    @stories
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
        "owner" => {"id" => owner.id, "name" => owner.name} }
  end
  
end

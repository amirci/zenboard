require 'agilezen'

class Project < AgileZenResource
  self.headers["X-Zen-ApiKey"] = "f7ba5d7ea3254f31aa15d17e3d4e8ee1"
  
  def created_on
    Time.at(createTime[6, 10].to_i)
  end
  
  def stories
    @stories = Story.all_for_project(id)
    @archived = @stories.find_all { |s| s.phase.name == 'Archive' }
    @stories
  end
  
  # Returns the sum of the size for all the archived stories
  def velocity
    @archived ||= []
    @archived.sum(&:size)
  end
  
  def throughput
    @archived ||= []
    @archived.count
  end
  
  def point_duration
    @archived ||= []
    @archived.sum(&:point_duration) / @archived.count
  end
  
  def to_hash
    { "id" => id,
        "name" => name,
        "description" => description,
        "createTime" => createTime,
        "owner" => {"id" => owner.id, "name" => owner.name} }
  end
  
end

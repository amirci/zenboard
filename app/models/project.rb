require 'agilezen'
require 'json_date'

class Project < AgileZenResource

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
  
  # Date when the project was created
  def created_on
    DateTime.parse(createTime)
  end

  # Returns the sum of the size for all the archived stories
  def velocity
    stories_in_archive.sum { |s| s.size.to_i }
  end
  
  # Amount of stories in archive
  def throughput
    stories_in_archive.count
  end
  
  # Amount of days per point using each story point duration
  def point_duration
    stories_in_archive.sum { |s| s.point_duration.to_f } / stories_in_archive.count
  end
  
  def to_hash
    { "id" => id,
        "name" => name,
        "description" => description,
        "createTime" => createTime,
        "owner" => { "id" => owner.id, "name" => owner.name} }
  end
  
  # responds to stories_in_xxx
  def respond_to?(sym)
    sym_stories_phase?(sym) || super(sym)
  end
  
  # implement stories_in_xxx
  # where xxx is a phase
  def method_missing(method_id, *args, &block)
    if match = sym_stories_phase?(method_id.to_s)
      stories.find_all { |s| s.phase.name.downcase == match.captures.first } 
    else
      super(method_id, *args, &block)
    end
  end

  private
    def sym_stories_phase?(sym)
      /stories_in_(\w+)/.match(sym)
    end
    
end

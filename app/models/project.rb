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

  # Amount of stories in archive
  def throughput
    stories_in_archive.count
  end

  def stories_with_tag(tag_id)
    stories.find_all { |s| !s.tags.nil? && s.tags.any? { |t| t.id.to_s == tag_id } } 
  end
  
  def tags
    stories.collect { |s| s.tags }.flatten.uniq { |t| t.id }.sort_by { |t| t.name }
  end
  
  # points per day
  def point_duration
    points = stories_in_archive.sum { |s| s.size.to_i }
    days = stories_in_archive.collect { |s| s.finished_on }.max - created_on
    weeks = days / 7
    days -= weeks * 2
    (points / days).to_f.round(2) rescue 0.0
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
      stories.find_all { |s| s.phase.name.downcase.include? match.captures.first } 
    else
      super(method_id, *args, &block)
    end
  end

  private
    def sym_stories_phase?(sym)
      /stories_in_(\w+)/.match(sym)
    end
    
end

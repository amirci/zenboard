require 'agilezen'
require 'json'

class Story < AgileZenResource
  self.headers["X-Zen-ApiKey"] = "f7ba5d7ea3254f31aa15d17e3d4e8ee1"
  self.prefix = "/api/v1/project"
  
  # Finds all storys for a particular project
  def self.all_for_project(id)
    self.nested = "/#{id}"
    all(:params => {:with => "metrics", :pageSize => 1000})
  end
  
  # Time when the story was placed on the board
  def started_on
    JSONHelper::Date.from_json(metrics.startTime) || Time.now
  end

  # Time when the story was moved to archive
  def finished_on
    metrics.respond_to?('finishTime') ? JSONHelper::Date.from_json(metrics.finishTime) : nil
  end
  
  # Conversion of points to days
  # by calculating size / (finish - start)
  def point_duration
    duration = finished_on - started_on
    size.to_i / duration * (24 * 60 * 60)
  end
  
  def to_hash
    { "id" => id, "text" => text, "size" => size, 
      "phase" => {"id" => phase.id, "name" => phase.name},
      "metrics" => metrics.to_hash }
  end
  
end

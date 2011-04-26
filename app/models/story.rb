require 'agilezen'
require 'json'

class Story < AgileZenResource  
  ApiPrefix = "/api/v1/projects"
  
  # Finds all storys for a particular project
  def self.all_for_project(id, api_key)
    self.headers["X-Zen-ApiKey"] = api_key
    self.prefix = "#{ApiPrefix}/#{id}/"
    
    all(:params => {:with => "metrics,tags", :pageSize => 1000})
  end
  
  def created_on
    (DateTime.parse(metrics.createTime) || Time.now) rescue Time.now
  end

  # Time when the story was placed on the board
  def started_on
    (DateTime.parse(metrics.startTime) || Time.now) rescue Time.now
  end

  # Time when the story was moved to archive
  def finished_on
    (metrics.respond_to?('finishTime') ? DateTime.parse(metrics.finishTime) : nil) rescue nil
  end
  
  # Conversion of points to days
  # by calculating size / (finish - start)
  def point_duration
    size.to_i == 0 ? 0 : work_time / size.to_i
  end
  
  def est_size(avg_point_duration)
    begin
      fib = [1, 3, 5, 8, 13, 20, 40, 80, 100]
      est = work_time / avg_point_duration
      dif = fib.collect { |x| (est - x).abs }
      index = dif.index dif.min
      fib[index]
    rescue
      0.0
    end
  end
  
  # Duration of the story (finish - start)
  def duration 
    (finished_on - started_on).to_f.round(2) rescue 0.0
  end
  
  # Amount of time the story was blocked
  def blocked_time
    metrics.blockedTime
  end
  
  # Amount of time waiting with ready features
  def waiting_time
    metrics.waitTime
  end
  
  # Amount of time working (no waiting or blocked)
  def work_time
    [0.0, duration - waiting_time - blocked_time].max
  end
  
  # % of time working of the total duration
  def efficiency
    duration == 0 ? 0 : (work_time / duration.to_f * 100).round
  end
  
  # Hashed version of the object
  def to_hash
    { "id" => id, "text" => text, "size" => size, 
      "phase" => {"id" => phase.id, "name" => phase.name},
      "metrics" => metrics.to_hash }
  end
  
end

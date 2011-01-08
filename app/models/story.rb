require 'agilezen'
require 'json'

class Story < AgileZenResource
  self.prefix = "/api/v1/project"
  
  def self.switch_https(use_https)
    protocol = "http" 
    protocol += "s" if use_https
    self.site = "#{protocol}://agilezen.com/api/v1/"
  end

  # Finds all storys for a particular project
  def self.all_for_project(id, api_key)
    self.headers["X-Zen-ApiKey"] = api_key
    self.nested = "/#{id}"
    
    retried = false
    
    begin
      all(:params => {:with => "metrics", :pageSize => 1000})
    rescue ActiveResource::Redirection => ex
      location = ex.response['Location']
      logger.error "Exception getting project stories detail, should redirect to #{location}"
      unless retried
        logger.error "Should redirect to #{location.include? 'https:'}"
        self.switch_https(location.include? 'https:')
        logger.error "Switching url to #{Project.site}"
        retried = true and retry # retry operation
      end
    end      
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
    size.to_i == 0 ? 0 : duration / size.to_i
  end
  
  # Duration of the story (finish - start)
  def duration 
    (finished_on - started_on) / (24 * 60 * 60)
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
    duration - waiting_time - blocked_time
  end
  
  # % of time working of the total duration
  def efficiency
    metrics.efficiency
  end
  
  # Hashed version of the object
  def to_hash
    { "id" => id, "text" => text, "size" => size, 
      "phase" => {"id" => phase.id, "name" => phase.name},
      "metrics" => metrics.to_hash }
  end
  
end

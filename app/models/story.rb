require 'agilezen'

class Story < AgileZenResource
  self.headers["X-Zen-ApiKey"] = "f7ba5d7ea3254f31aa15d17e3d4e8ee1"
  self.prefix = "/api/v1/project"
  
  def self.all_for_project(id)
    self.nested = "/#{id}"
    all(:params => {:with => "metrics"})
  end
  
  def started_on
    Time.at(metrics.startTime[6..15].to_i)
  end

  def finished_on
    Time.at(metrics.finishTime[6..15].to_i)
  end
end

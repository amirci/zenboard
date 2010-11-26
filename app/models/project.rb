require 'agilezen'

class Project < AgileZenResource
  self.headers["X-Zen-ApiKey"] = "f7ba5d7ea3254f31aa15d17e3d4e8ee1"
  
  def created_on
    Time.at(createTime[6..15].to_i)
  end
end

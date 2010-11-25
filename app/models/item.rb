class Item < ActiveResource::Base
  self.site = "http://agilezen.com/api/v1/"
  self.headers["X-Zen-ApiKey"] = "f7ba5d7ea3254f31aa15d17e3d4e8ee1"
  self.format = :json
  self.element_name = "project"
  

  
end

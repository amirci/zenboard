class AgileZenResource < ActiveResource::Base
  self.site = "https://agilezen.com/api/v1/"
  self.format = :json
  
  class << self    

    def instantiate_collection(collection, prefix_options = {})
      collection["items"].collect! do |record| 
        instantiate_record(record, prefix_options)
      end
    end  

  end
  
end
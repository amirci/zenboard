class KanbanFuResource < ActiveResource::Base
  self.site = "http://localhost:3010"
  self.format = :json
  
  class << self    

    def instantiate_collection(collection, prefix_options = {})
      collection = collection[element_name.pluralize] if collection.instance_of?(Hash)       
      collection.collect! { |record| instantiate_record(record, prefix_options) }
    end  

  end
end


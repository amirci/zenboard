class AgileZenResource < ActiveResource::Base
  self.site = "http://agilezen.com/api/v1/"
  self.format = :json
  
  class << self
    
    attr_accessor :nested
    
    ## Remove format from the url.
    def element_path(id, prefix_options = {}, query_options = nil)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}#{element_name}/#{id}#{query_string(query_options)}"
    end
    
    ## Remove format from the url.
    def collection_path(prefix_options = {}, query_options = nil)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      nested_options = "#{self.nested}/" if self.nested 
      "#{prefix(prefix_options)}#{nested_options}#{collection_name}#{query_string(query_options)}"
    end

    def instantiate_collection(collection, prefix_options = {})
      collection["items"].collect! do |record| 
        instantiate_record(record, prefix_options)
      end
    end  

  end
  
  self.nested = ""
  
end
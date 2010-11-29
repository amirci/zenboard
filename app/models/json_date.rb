# Helper class to encode and decode JSON dates
class JSONHelper
  
  class Date
    # Converts a date to JSON format
    def self.to_json(date)
       "\/Date(#{date.to_i}000-600)\/"
    end
  
    # Converst a JSON date to Time
    def self.from_json(json)
      Time.at(json[6, 10].to_i)
    end
  end  
  
end
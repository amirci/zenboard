require 'json'

class Metrics
  attr_accessor :createTime, :startTime, :finishTime

  # Initializes the metrics class with a hash of attributes
  def initialize(attributes = {})
    @createTime = attributes["createTime"] || ""
    @startTime  = attributes["startTime"]  || ""
    @finishTime = attributes["finishTime"] || ""
  end

  # Hash serialization to use for JSON
  def to_hash
    { "createTime" => createTime, 
      "startTime"  => startTime,
      "finishTime" => finishTime }
  end
  
end
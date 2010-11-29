require 'json'

class Metrics
  attr_accessor :createTime, :startTime, :finishTime
  attr_accessor :leadTime, :blockedTime, :waitTime, :cycleTime, :workTime, :efficiency

  # Initializes the metrics class with a hash of attributes
  def initialize(attributes = {})
    @createTime  = attributes["createTime"] || ""
    @startTime   = attributes["startTime"]  || ""
    @finishTime  = attributes["finishTime"] || ""
    @leadTime    = attributes["leadTime"]   || 0
    @blockedTime = attributes["blockedTime"] || 0
    @waitTime    = attributes["waitTime"]    || 0
    @cycleTime   = attributes["cycleTime"]   || 0
    @workTime    = attributes["workTime"]    || 0
    @efficiency  = attributes["efficiency"]  || 0
  end

  # Hash serialization to use for JSON
  def to_hash
    m = public_methods.find_all {|m| m.include?('=')}
    m = m.reject { |m| m == "==" || m == "===" || m == "=~" || m == "taguri=" }
    m = m.collect { |m| m.delete('=') }          
    m.inject({}) do |h, name| 
      h[name] = send(name) 
      h
    end
  end
  
end
class Phase
  attr_accessor :id, :name
  
  def initialize(attributes = {})
    @id = attributes["id"] || 0
    @name = attributes["name"] || ''
  end
end
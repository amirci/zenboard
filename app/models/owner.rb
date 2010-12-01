class Owner
  attr_accessor :id, :name
  
  def initialize(attributes = {})
    @id = attributes["id"] || 0
    @name = attributes["name"] || 'Charles Xavier'
  end
    
  def ==(other)
    @id == other.id && @name == other.name
  end

  alias eql? ==
end
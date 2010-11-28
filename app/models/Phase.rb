class Phase
  attr_reader :id, :name
  
  def initialize(id, name = "Phase")
    @id = id
    @name = name
  end
end
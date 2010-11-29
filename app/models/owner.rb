class Owner
  attr_reader :id, :name
  
  def initialize(id, name = 'Charles Xavier')
    @id = id
    @name = name
  end
end
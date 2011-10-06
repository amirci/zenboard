class KfuStory < KanbanFuResource
  self.site = "http://localhost:3010/projects/:project_id/"
  self.element_name = "card"
  
  def phase
    Phase.new('Archive')
  end
  
  def size
    3
  end
  
  def started_on
    DateTime.now
  end
  
  def finished_on
    started_on + 3
  end
  
  def efficiency
    90
  end
  
  def tags
    []
  end
end
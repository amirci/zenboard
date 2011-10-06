class KFuProject < KanbanFuResource
  include StoryMetrics
  
  self.element_name = "project"
  
  def stories
    []
  end
  
  def each(&block)
    stories.each(&block)
  end
end
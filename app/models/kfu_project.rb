class KfuProject < KanbanFuResource
  include StoryMetrics
  
  self.element_name = "project"
  
  def self.find1(*arguments)
    result = super.find(arguments)
    return result if result.kind_of?(Enumerator)
    KfuProject.new(result.project.attributes)
  end
  
  def stories
    [] #KfuStory.find(:all, params: { project_id: attributes[:id] })
  end
  
  def each(&block)
    stories.each(&block)
  end
  
  def created_on
    DateTime.now
  end
  
end
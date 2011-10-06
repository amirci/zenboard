class KfuProject < KanbanFuResource
  include StoryMetrics
  
  self.element_name = "project"
  
  class << self
    alias :old_find :find
    
    def find(*arguments)
      scope = arguments.first
      case scope
        when :all   then old_find(*arguments)
        when :first then old_find(*arguments)
        when :one   then old_find(*arguments)
        else        old_find(:all).select { |p| p.id == scope }.first
      end
    end
  end
      
  def stories
    KfuStory.find(:all, params: { project_id: attributes[:id] })
  end
  
  def each(&block)
    stories.each(&block)
  end
  
  def created_on
    DateTime.now
  end
  
end
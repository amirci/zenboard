class KfuStory < KanbanFuResource
  attr_accessor :project

  self.site = "http://localhost:3010/projects/:project_id/"
  self.element_name = "card"
  
  def text
    description
  end
  
  def phase
    Phase.new('Archive')
  end
  
  def size
    3
  end
  
  def point_duration
    size / duration
  end
  
  def duration
    (finished_on - started_on).to_f.round(2)
  end
  
  def work_time
    duration - blocked_time - waiting_time
  end
  
  def started_on
    DateTime.now - 10
  end
  
  def finished_on
    started_on + 3
  end
  
  def efficiency
    (work_time/ duration * 100).round(2)
  end
  
  def tags
    []
  end
  
  def blocked_time
    duration * 0.10
  end
  
  def waiting_time
    duration * 0.05
  end
  
  def color
    'teal'
  end
end
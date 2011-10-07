class KfuStory < KanbanFuResource
  attr_accessor :project

  self.site = "http://localhost:3010/projects/:project_id/"
  self.element_name = "card"
  
  def text
    description
  end
  
  def phase
    Phase.find_by_name(self.attributes['phase'])
  end
  
  def finished_on
    DateTime.parse(self.attributes['finished_on'])
  end
  
  def started_on
    DateTime.parse(self.attributes['started_on'])
  end

  def point_duration
    (size / duration) rescue 0
  end
  
  def duration
    (finished_on - started_on).to_f.round(2) rescue 0
  end
  
  def work_time
    duration - blocked_time - waiting_time
  end
  
  def efficiency
    (work_time/ duration * 100).round(2) rescue 0
  end
  
  def tags
    []
  end
  
  def color
    'gray'
  end
end
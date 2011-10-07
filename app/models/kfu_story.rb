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
    finished = self.attributes['finished_on']
    finished.nil? ? nil : DateTime.parse(finished)
  end
  
  def started_on
    started = self.attributes['started_on']
    started.nil? ? nil : DateTime.parse(started)
  end

  def point_duration
    (size / duration) rescue 0
  end
  
  def duration
    return nil unless finished_on
    (finished_on - started_on).to_f.round(2)
  end
  
  def work_time
    return nil unless duration
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
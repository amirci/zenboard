module StoryMetrics 
  include Enumerable
  
  def points
    sum { |s| s.size.to_i }
  end
  
  def started_on
    min_by(&:started_on).started_on
  end
  
  def completed_on
    max_by(&:finished_on).finished_on
  end
  
  def duration
    completed_on - started_on
  end
  
  def velocity
    points.to_f / Week.since(started_on).count.to_f
  end

  def point_duration
    days = duration - Week.since(started_on).count * 2
    points.to_f / days
  end

  # responds to stories_in_xxx
  def respond_to?(sym)
    sym_stories_phase?(sym) || super(sym)
  end
  
  # implement stories_in_xxx
  # where xxx is a phase
  def method_missing(method_id, *args, &block)
    if match = sym_stories_phase?(method_id.to_s)
      find_all { |s| s.phase.name.downcase.include? match.captures.first } 
    else
      super(method_id, *args, &block)
    end
  end

  private
    def sym_stories_phase?(sym)
      /in_(\w+)/.match(sym.to_s)
    end
end

class Array
  include StoryMetrics
end
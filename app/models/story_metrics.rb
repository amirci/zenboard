module StoryMetrics 
  include Enumerable
  
  def points
    sum { |s| s.size.to_i }
  end
  
  def efficiency
    collected = select { |s| s.respond_to? :efficiency }.collect(&:efficiency).reject { |d| d.nil? }
    collected.sum / collected.count
  end
  
  def started_on
    collect(&:started_on).reject { |d| d.nil? }.min
  end
  
  def completed_on
    collect(&:finished_on).reject { |d| d.nil? }.max
  end
  
  def duration
    (completed_on - started_on) rescue 'n/a'
  end
  
  def velocity(group = :week)
    points.to_f / Week.since(started_on).count.to_f
  end

  def point_duration
    # days is adjustes to ignore weekends
    days = duration - duration / 7 * 2
    days / points.to_f
  rescue
    'n/a'
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
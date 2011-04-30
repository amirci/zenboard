module MetricsHelper
  def throughput(project)
    pluralize(project.throughput, "story")
  end

  def stories(stories)
    pluralize(stories.count, "story") + " (#{points(stories)})"
  end
  
  def points(stories)
    pluralize(stories.points, "point") rescue 'n/a'
  end
  
  def velocity(stories)
    pluralize(stories.velocity.round(2), "point") + " (week)" rescue 'n/a'
  end
  
  def point_duration(stories)
    pluralize(stories.point_duration.round(2), "day") rescue 'n/a'
  end

  def duration(stories)
    pluralize(stories.duration.to_f.round(2), "day") rescue 'n/a'
  end
  
  def efficiency(monthly_summary)
    value = monthly_summary.sum { |m| m.efficiency } / monthly_summary.count rescue 0
    "#{value} %" rescue 'n/a'
  end
  
  def time_left(stories, project)
    value = stories.points * project.point_duration
    pluralize(value.round.to_i, "day") rescue 'n/a'
  end

  def eta(stories, project)
    value = stories.points * project.point_duration
    (Date.today + value.round).strftime('%b %d %Y')
  end
  
  def completed_date(stories)
    stories.completed_on.strftime('%b %d %Y')
  end

  def started_date(stories)
    stories.started_on.strftime('%b %d %Y')
  end
end
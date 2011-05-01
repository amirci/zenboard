require 'story_metrics'

module MetricsHelper
  def stories(stories)
    pluralize(stories.count, "story") + " (#{points(stories)})"
  end
  
  def points(stories)
    pluralize(stories.points, "point") rescue 'n/a'
  end
  
  def velocity(stories, type = :weekly)
    pluralize(stories.velocity.round(2), "point") + " (week)" rescue 'n/a'
  end
  
  def point_duration(stories)
    pluralize(stories.point_duration.round(2), "day") rescue 'n/a'
  end

  def duration(stories)
    pluralize(stories.duration.to_f.round(2), "day") rescue 'n/a'
  end
  
  def efficiency(stories)
    "#{stories.efficiency} %" rescue 'n/a'
  end
  
  def time_left(stories, prj_pd, st_pd)
    prj_time_left = (stories.points * prj_pd).round.to_i rescue 0
    st_time_left = (stories.points * st_pd).round.to_i rescue 0
    "#{pluralize(st_time_left,'day')} (#{pluralize(prj_time_left, 'day')})" rescue 'n/a'
  end

  def eta(stories, prj_pd, st_pd)
    prj_time_left = (stories.points * prj_pd).round.to_i rescue 0
    st_time_left = (stories.points * st_pd).round.to_i rescue 0
    "#{date_format_long(Date.today + st_time_left)} (#{date_format_long(Date.today + prj_time_left)})"
  end
  
  def completed_date(stories)
    stories.completed_on.strftime('%b %d %Y')
  end

  def started_date(stories)
    stories.started_on.strftime('%b %d %Y')
  end
end
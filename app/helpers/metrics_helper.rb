require 'story_metrics'

module MetricsHelper
  def stories(stories)
    result = pluralize(stories.count, "story") 
    result << " (#{points(stories)})" unless stories.empty?
    result
  end
  
  def points(stories)
    pluralize(stories.points, "point") rescue 'n/a'
  end
  
  def velocity(stories, type = :weekly)
    vel = stories.velocity.round(2)
    return 'n/a' if vel == 0.0
    pluralize(vel, "point") + " (week)" rescue 'n/a'
  end
  
  def point_duration(stories)
    pluralize(stories.point_duration.round(2), "day")
  end

  def duration(stories)
    return 'n/a' if stories.started_on.nil?
    pluralize(stories.duration.to_f.round(2), "day") rescue 'n/a'
  end
  
  def efficiency(stories)
    "#{stories.efficiency} %" rescue 'n/a'
  end
  
  def time_left(stories, prj_pd, st_pd)
    prj_time_left = (stories.points * prj_pd).round.to_i rescue 0
    st_time_left = (stories.points * st_pd).round.to_i rescue 0
    prj_estimation = pluralize(prj_time_left, 'day')
    return prj_estimation if st_time_left == 0
    "#{pluralize(st_time_left,'day')} (#{prj_estimation})" rescue 'n/a'
  end

  def eta(stories, prj_pd, st_pd)
    prj_time_left = (stories.points * prj_pd).round.to_i rescue 0
    st_time_left = (stories.points * st_pd).round.to_i rescue 0
    prj_estimation = date_format_long(Date.today + prj_time_left)
    return prj_estimation if st_time_left == 0
    "#{date_format_long(Date.today + st_time_left)} (#{prj_estimation})"
  end
  
  def completed_date(stories)
    stories.completed_on.strftime('%b %d %Y')
  end

  def started_date(stories)
    date_format_long(stories.started_on) rescue 'n/a'
  end
end
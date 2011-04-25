module ApplicationHelper  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def markdown(str)
    raw(BlueCloth.new(str).to_html)
  end

  def link_to_story(story)
    story_url = "https://agilezen.com/project/#{story.project.id}/story/#{story.id}"
    link_to(story.id, story_url, :target => "_blank")
  end

  def date_format(date)
    date.strftime('%b %d') rescue 'n/a'
  end

  def throughput(project)
    pluralize(project.throughput, "story")
  end

  def stories(stories)
    pluralize(stories.count, "story")
  end
  
  def points(stories)
    value = stories.sum { |s| s.size.to_i }
    pluralize(value, "point") rescue 'n/a'
  end
  
  def velocity(monthly_summary)
    value = monthly_summary.sum { |m| m.velocity } / monthly_summary.count rescue 0
    pluralize(value, "point") rescue 'n/a'
  end
  
  def point_duration(monthly_summary)
    value = monthly_summary.point_duration 
    #value = monthly_summary.sum { |m| m.point_duration } / monthly_summary.count rescue 0
    pluralize(value.round(2), "day") rescue 'n/a'
  end

  def efficiency(monthly_summary)
    value = monthly_summary.sum { |m| m.efficiency } / monthly_summary.count rescue 0
    "#{value} %" rescue 'n/a'
  end
  
  def time_left(stories, project)
    value = stories.sum { |s| s.size.to_i } * project.point_duration
    pluralize(value.round.to_i, "day") rescue 'n/a'
  end

  def finish_date(stories, project)
    value = (stories.sum { |s| s.size.to_i } * project.point_duration).round
    (Date.today + value).strftime('%b %d %Y')
  end
  
  def velocity_graph(months, size = "600x250")
    title = "Velocity by month"
    sorted = months.sort_by { |m| m.date }
    velocities = sorted.collect { |m| m.velocity }
    labels = sorted.collect { |m| m.date.strftime('%b %y')}
    
    if months.count == 1
      title = "Velocity by week"
    end

    lc = GoogleChart::LineChart.new(size, title, false)
    lc.data "Velocity", velocities, '4b7399'
    lc.axis :y, :range => [0, velocities.max], :font_size => 10, :alignment => :center
    lc.axis :x, :labels => labels, :font_size => 10, :alignment => :center
    lc.show_legend = false
    lc.fill_area 'D0DAFD', 0, 0
    lc.shape_marker :circle, :color => '0767C1', :data_set_index => 0, :data_point_index => -1, :pixel_size => 8
    lc.to_url
  end
end

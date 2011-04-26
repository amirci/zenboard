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
    
    lc = GoogleChart::LineChart.new(size, title, false)
    lc.data "Velocity", velocities, '4b7399'
    lc.axis :y, :range => [0, velocities.max], :font_size => 10, :alignment => :center
    lc.axis :x, :labels => labels, :font_size => 10, :alignment => :center
    lc.show_legend = false
    lc.fill_area 'D0DAFD', 0, 0
    lc.shape_marker :circle, :color => '0767C1', :data_set_index => 0, :data_point_index => -1, :pixel_size => 8
    lc.to_url
  end
  
  def burn_down_graph(stories)
    started = stories.collect { |s| s.started_on }.min

    weeks = Week.since(started)

    backlog = {}
    
    by_week = weeks.inject({}) do |hash, week|
      hash[week] = stories.find_all { |s| !s.finished_on.nil? && s.finished_on <= week.finish }
      backlog[week] = stories.find_all { |s| s.created_on <= week.finish }
      hash
    end
    
    stories.find_all { |s| s.created_on <= Date.today }.each do |s|
      puts "**** The story #{s.id} was created on #{s.created_on}"
    end
    
    stories.find_all { |s| s.created_on <= weeks.first.finish }.each do |s|
      puts "**** The story #{s.id} was created on #{s.created_on} and #{weeks.first.finish}"
    end
    
    
    by_week = by_week.sort { |a, b| b[0] <=> a[0] }
    
    totals = by_week.collect { |week, stories| backlog[week].count - stories.count }
    
    labels = by_week.collect { |week, stories| week.start.strftime('%b %d')}
    
    backlog = backlog.collect { |w, s| s.count }
    by_week = by_week.collect { |w, s| s.count }
    puts "**** The backlog values are : #{backlog.inspect}"
    puts "**** The by week values are : #{by_week.inspect}"
    puts "**** The weeks values are : #{labels.inspect}"
    puts "**** The burn down values are : #{totals.inspect}"

    title = "Burndown by week"
    
    if totals.count > 12 
      
      title = "Burndown by 2 weeks"
      i = 0
      t2 = []
      l2 = []
      while i < totals.count - 1  
        t2 << backlog[i+1] - by_week[i+1]
        l2 << labels[i]
        i += 2        
      end
      t2 << backlog.last - by_week.last unless totals.count % 2 == 0
      l2 << labels.last unless totals.count % 2 == 0
      totals = t2
      labels = l2

      puts "**** The burn down values are : #{totals.inspect}"
      puts "**** The weeks values are : #{labels.inspect}"
    end
    

    lc = GoogleChart::BarChart.new("600x250", title, :vertical, false)
    lc.data "To Do", totals, '4b7399'
    lc.width_spacing_options :bar_spacing => 40, :bar_width => 25, :group_spacing => totals.count < 8 ? 40 : 15
    lc.axis :y, :range => [0, totals.max], :font_size => 10, :alignment => :center
    lc.axis :x, :labels => labels, :font_size => 10, :alignment => :center
    lc.to_url
        
    #lc = GoogleChart::LineChart.new("600x250", title, false)
    #lc.data "Backlog", totals, '4b7399'
    #lc.axis :y, :range => [0, totals.max], :font_size => 10, :alignment => :center
    #lc.axis :x, :labels => labels, :font_size => 10, :alignment => :center
    #lc.show_legend = false
    #lc.fill_area 'D0DAFD', 0, 0
    #lc.shape_marker :circle, :color => '0767C1', :data_set_index => 0, :data_point_index => -1, :pixel_size => 8
    #lc.to_url
  end
end

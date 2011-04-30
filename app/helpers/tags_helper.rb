require 'google_chart'

module TagsHelper

  def tag_selection(project, selected_tag)
    tags = project.tags.collect { |t| [t.name, t.id] }
    script = "document.location='/projects/#{project.id}/tags/' + this.value"
    combo = select("tag", "name", tags, {:selected => selected_tag.id}, {:onchange => script})
    label_tag('Change Tag') << ": " << combo
  end
  
  def tag_charts(completed, not_completed)
    content_tag(:img, nil, :id => "c1", :src => burn_down_graph(completed + not_completed)) + 
    (!not_completed.empty? ? content_tag(:img, nil, :id => "c2", :src => phases_graph(completed + not_completed)) : "");
  end
  
  def tag_metrics(completed, not_completed, project)
    finished = not_completed.empty?
    all = completed + not_completed
    col = 0
    
    content  = column_metrics(col += 1, 'total', stories(all), 'velocity', velocity(completed)) 
    content << column_metrics(col += 1, 'eff.', efficiency(completed), '1 point', point_duration(completed))
    
    if finished
      content << column_metrics(col += 1, 'started on', started_date(all), 'finished on', completed_date(all))  
      content << column_metrics(col += 1, 'duration', duration(all))  
    else
      content << column_metrics(col += 1, 'completed', stories(completed), 'left to do', stories(not_completed)) 
      content << column_metrics(col += 1, 'time to finish', time_left(not_completed, project), 'ETA', eta(not_completed, project))  
    end
    content
  end
  
  def column_metrics(id, *values)
    content_tag(:div, nil, :id => "c#{id}") { column_contents(*values) }
  end
  
  def column_contents(*values)
    return if values.nil? || values.empty? || values.first.nil?
    content_tag(:p, label_tag(values[0]) + ": #{values[1]}") + column_contents(*values[2..-1])
  end
    
  def story_tables_by_phase(completed, not_completed)
    all = (completed + not_completed).group_by { |s| s.phase.name }
    headers = %w{Id Text Size Start Fin. 1\ Pt. Dur. Block Wait AWork Eff.\ %}
    ths = headers.inject(ActiveSupport::SafeBuffer.new) { |c, header| c.concat content_tag(:th, header) } 
    
    all.inject(ActiveSupport::SafeBuffer.new) do |c, pair|
      phase = pair[0]
      stories = pair[1]
      c << content_tag(:div, nil, :id => "title") { "#{phase} (#{stories.count}) " + link_to_function("(+/-)", "Element.toggle('div_#{phase}')") }
      c << content_tag(:table, nil, :id => "div_#{phase}") do
        content_tag(:thead) { content_tag(:tr) { ths } } +
        content_tag(:tbody) { render(:partial => "projects/story", :collection => stories )  } ;
      end
    end
  end
  
  # Bar chart by Phase
  def phases_graph(stories)
    by_phase = stories.group_by { |s| s.phase.name }    
    chart = GoogleChart::PieChart.new('500x200', "Phase distribution", true)
    by_phase.each { |k, v| chart.data "#{k} (#{v.count})", v.count }
    chart.to_url
  end

  def burn_down_graph(stories)
    started = stories.started_on

    weeks = Week.since(started).reverse

    backlog = []

    completed = []
    
    labels = []
    
    burn_down = []

    weeks.each do |week|
      completed << stories.find_all { |s| !s.finished_on.nil? && s.finished_on <= week.finish }
      backlog   << stories.find_all { |s| s.created_on <= week.finish }
      labels    << week.start.strftime('%b %d')
      burn_down << backlog.last.points - completed.last.points
    end

    # Adjust if were all completed
    ri = burn_down.rindex { |x| x > 0 }
    count = burn_down.size - ri - 2
    burn_down.pop(count) if count > 0
    
    title = "Burndown by week"
    
    if burn_down.count > 12      
      title = "Burndown by 2 weeks iterations"
      i = 0
      t2 = []
      l2 = []
      while i < burn_down.count - 1  
        t2 << burn_down[i+1]
        l2 << labels[i]
        i += 2        
      end
      t2 << burn_down.last unless burn_down.count % 2 == 0
      l2 << labels.last unless burn_down.count % 2 == 0
      burn_down = t2
      labels = l2
    end
    
    lc = GoogleChart::BarChart.new("500x250", title, :vertical, false)
    lc.data "To Do", burn_down, '4b7399'
    lc.width_spacing_options :bar_spacing => 40, :bar_width => 25, :group_spacing => burn_down.count < 8 ? 40 : 15
    lc.axis :y, :range => [0, burn_down.max], :font_size => 10, :alignment => :center
    lc.axis :x, :labels => labels, :font_size => 10, :alignment => :center
    lc.to_url
  end  
end

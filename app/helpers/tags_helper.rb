module TagsHelper

  def tag_status(stories)
    return "(complete)" if @not_completed.empty?
    return "(in progress)" if @not_completed.any? { |s| s.phase.name != 'Backlog' }
    "(not started)"
  end
  
  def tag_header(project, tag)
    content = content_tag(:div, nil, :id => "c1") { link_to "Back to details", project_path(project) }
    content << content_tag(:div, nil, :id => "c2") { tag_selection(project, tag) }
  end
  
  def tag_selection(project, selected_tag)
    tags = project.tags.collect { |t| [t.name, t.id] }
    script = "document.location='/projects/#{project.id}/tags/' + this.value"
    combo = select("tag", "name", tags, {:selected => selected_tag.id}, {:onchange => script})
    label_tag('Change Tag') << ": " << combo
  end
  
  def tag_charts(completed, not_completed)
    content = content_tag(:img, nil, :id => "c1", :src => burn_down_chart(completed + not_completed)) 
    content << content_tag(:img, nil, :id => "c2", :src => phases_chart(completed + not_completed)) unless not_completed.empty?
    content
  end
  
  def tag_metrics(completed, not_completed, project)
    finished = not_completed.empty?
    all = completed + not_completed
    col = 0
    
    content  = column_metrics(col += 1, 'total', stories(all), 'velocity', velocity(completed)) 
    content << column_metrics(col += 1, 'eff.', efficiency(completed), '1 point', point_duration(completed))
    content << column_metrics(col += 1, 'started on', started_date(all), 'duration', duration(all))  
    
    if finished
      content << column_metrics(col += 1, 'finished on', completed_date(all))  
    else
      content << column_metrics(col += 1, 'completed', stories(completed), 'left to do', stories(not_completed)) 
      content << column_metrics(col += 1, 'time to finish', time_left(not_completed, project.point_duration, completed.point_duration) \
                                        , 'eta', eta(not_completed, project.point_duration, completed.point_duration))  
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
    
  def stories_by_phase(stories)
    by_phase = stories.group_by { |s| s.phase.name }
    story_tables(by_phase) { |phase, stories| "#{phase} (#{stories.count})" }
  end
end

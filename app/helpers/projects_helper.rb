require 'google_chart'

module ProjectsHelper
    
  def story_text(story)
    str = story.text
    # show new lines as paragraphs
    str.gsub!("\n", "\n\n")
    markdown(auto_link(str + story_tags(story), :all, :target => "_blank"))
  end

  def story_tags(story)
    return if story.tags.nil?
    "\n\n" + story.tags.collect { |tag| link_to(tag.name, project_tag_path(story.project, tag)) + " " }.to_s
  end
  
  def link_to_month(month, project)
    link_to month.date.strftime("%b '%y"), \
            project_path(project.id, :month => month.date.strftime('%Y-%m-01'))
  end
  
  def size_format(story, avg_point_duration)
    est = story.est_size(avg_point_duration)
    add = " (#{est})" if est != story.size.to_i && story.finished_on
    "#{story.size}#{add}"
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
end

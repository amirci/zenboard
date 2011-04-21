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
  
  def velocity_graph(months, size = "600x250")
    lc = GoogleChart::LineChart.new(size, "Velocity by month", false)
    sorted = months.sort_by { |m| m.date }
    velocities = sorted.collect { |m| m.velocity }
    lc.data "Velocity", velocities, '4b7399'
    lc.axis :y, :range => [0, velocities.max], :font_size => 10, :alignment => :center
    lc.axis :x, :labels => sorted.collect { |m| m.date.strftime('%b %y')}, :font_size => 10, :alignment => :center
    lc.show_legend = false
    lc.fill_area 'D0DAFD', 0, 0
    lc.shape_marker :circle, :color => '0767C1', :data_set_index => 0, :data_point_index => -1, :pixel_size => 8
    lc.to_url
  end
end

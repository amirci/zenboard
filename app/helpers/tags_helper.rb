require 'google_chart'

module TagsHelper

  # Bar chart by Phase
  def phases_graph(stories)
    chart = GoogleChart::PieChart.new('500x200', "Phase distribution", true)
    stories.each { |k, v| chart.data "#{k} (#{v.count})", v.count }
    chart.to_url
  end

  # Helper to generate tag selection
  def change_tag_selection(project, selected, api_key)
    tags = project.tags.collect { |t| [t.name, t.id] }
    script = "document.location='/projects/#{project.id}/tags/' + this.value + '?api_key=#{api_key}'"
    select("tag", "name", tags, {:selected => selected.id}, {:onchange => script})
  end

  def burn_down_graph(stories)
    started = stories.collect { |s| s.started_on }.min

    weeks = Week.since(started).reverse

    backlog = []

    completed = []
    
    labels = []
    
    burn_down = []

    weeks.each do |week|
      completed << stories.find_all { |s| !s.finished_on.nil? && s.finished_on <= week.finish }
      backlog   << stories.find_all { |s| s.created_on <= week.finish }
      labels    << week.start.strftime('%b %d')
      burn_down << backlog.last.count - completed.last.count
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
    
    lc = GoogleChart::BarChart.new("600x250", title, :vertical, false)
    lc.data "To Do", burn_down, '4b7399'
    lc.width_spacing_options :bar_spacing => 40, :bar_width => 25, :group_spacing => burn_down.count < 8 ? 40 : 15
    lc.axis :y, :range => [0, burn_down.max], :font_size => 10, :alignment => :center
    lc.axis :x, :labels => labels, :font_size => 10, :alignment => :center
    lc.to_url
  end  
end

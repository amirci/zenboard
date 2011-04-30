require 'google_chart'

module ChartsHelper
  
  # Bar chart by Phase
  def phases_chart(stories)
    by_phase = stories.group_by { |s| s.phase.name }    
    chart = GoogleChart::PieChart.new('500x200', "Phase distribution", true)
    by_phase.each { |k, v| chart.data "#{k} (#{v.count})", v.count }
    chart.to_url
  end

  def burn_down_chart(stories)
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
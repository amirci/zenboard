require 'google_chart'

module TagsHelper

  # Bar chart by Phase
  def phases_graph(stories)
    chart = GoogleChart::PieChart.new('500x200', "Phase distribution", true)
    stories.each { |k, v| chart.data "#{k} (#{v.count})", v.count }
    chart.to_url
  end

  # Helper to generate tag selection
  def change_tag_selection(project, selected, tags, api_key)
    tags = @tags.collect { |t| [t.name, t.id] }
    script = "document.location='/projects/#{@project.id}/tags/' + this.value + '?api_key=#{api_key}'"
    select("tag", "name", tags, {:selected => selected.id}, {:onchange => script})
  end
  
end

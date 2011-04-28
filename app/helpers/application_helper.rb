module ApplicationHelper  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def project_selection(selected)
    return unless current_user
    projects = current_user.configurations.collect { |p| [p.name, p.project_id] }
    script = "document.location='/projects/' + this.value"
    selected ||= current_user.configurations.first
    select("tag", "name", projects, {:selected => selected.id}, {:onchange => script})
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
    pluralize(stories.count, "story") + " (#{points(@completed)})"
  end
  
  def points(stories)
    pluralize(stories.points, "point") rescue 'n/a'
  end
  
  def velocity(stories)
    pluralize(stories.velocity, "point") rescue 'n/a'
  end
  
  def point_duration(stories)
    pluralize(stories.point_duration.round(2), "day") rescue 'n/a'
  end

  def duration(stories)
    pluralize(stories.duration.to_f.round(2), "day") rescue 'n/a'
  end
  
  def efficiency(monthly_summary)
    value = monthly_summary.sum { |m| m.efficiency } / monthly_summary.count rescue 0
    "#{value} %" rescue 'n/a'
  end
  
  def time_left(stories, project)
    value = stories.points * project.point_duration
    pluralize(value.round.to_i, "day") rescue 'n/a'
  end

  def estimated_finish_date(stories, project)
    value = stories.points * project.point_duration
    (Date.today + value.round).strftime('%b %d %Y')
  end
  
  def completed_date(stories)
    stories.completed_on.strftime('%b %d %Y')
  end

  def started_date(stories)
    stories.started_on.strftime('%b %d %Y')
  end
end

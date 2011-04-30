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
end

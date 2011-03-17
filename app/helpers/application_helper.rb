module ApplicationHelper  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def story_link(story)
    link_to(story.id, "https://agilezen.com/project/#{story.project.id}/story/#{story.id}", :target => "_blank")
  end
  
end

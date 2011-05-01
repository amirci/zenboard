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

  # Shows the tables of stories for each week
  def stories_by_week(by_week)
    sorted = by_week.sort { |k1, k2| k1[0].start <=> k2[0].start }.reverse      
    story_tables(sorted) { |w, stories| "#{w.start.strftime('%b %d')} to #{w.finish.strftime('%b %d')}" }
  end
  
end
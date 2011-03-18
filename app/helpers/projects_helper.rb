module ProjectsHelper
    
  def story_text(str)
    # show new lines as paragraphs
    str.gsub!("\n", "\n\n")
    markdown auto_link(str, :all, :target => "_blank")
  end

  def link_to_month(month, project)
    link_to month.date.strftime("%b '%y"), \
            project_path(project.id, :api_key => Project.api_key, :month => month.date.strftime('%Y-%m-01'))
  end
  
end

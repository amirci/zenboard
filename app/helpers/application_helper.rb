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

  def date_format_long(date)
    date.strftime('%b %d %Y') rescue 'n/a'
  end
  
  # Creates a table for the stories grouped by the key in the hash
  def story_tables(story_hash)
    headers = %w{Id Text Size Start Fin. 1\ Pt. Dur. Block Wait AWork Eff}
    ths = headers.inject(ActiveSupport::SafeBuffer.new) { |c, header| c.concat content_tag(:th, header) } 

    story_hash.inject(ActiveSupport::SafeBuffer.new) do |c, pair|
      key, stories = pair[0], (pair[1].sort_by(&:finished_on).reverse rescue pair[1])
      c << content_tag(:div, nil, :id => "title") do
         link_to_function("+/-", "Element.toggle('div_#{key}')", :class => "hide_show") + yield(key, stories)
      end
      c << content_tag(:table, nil, :id => "div_#{key}") do
        content_tag(:thead) { content_tag(:tr) { ths } } \
        << content_tag(:tbody) { render(:partial => "projects/story", :collection => stories )  } 
      end
    end
  end
end

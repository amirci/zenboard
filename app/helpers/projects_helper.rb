
module ProjectsHelper

  def markdown(str)
    raw(BlueCloth.new(str).to_html)
  end
    
  def story_text(str)
    # show new lines as paragraphs
    str.gsub!("\n", "\n\n")
    markdown auto_link(str, :all, :target => "_blank")
  end
  
end

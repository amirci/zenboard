class TagsController < ApplicationController
  before_filter :authenticate_user!, :find_project
  
  def show
    tagged = @project.stories_with_tag(params[:id])
                  
    @completed = tagged.find_all { |s| s.phase.name.downcase.include? 'archive' }
    
    @not_completed = tagged - @completed
    
    @tag = tagged.first.tags.find { |t| t.id.to_s == params[:id] } unless tagged.empty?

    #@monthly_summary = monthly_summary(@completed)
    
    @completed = StoryCollection.new @completed
    @not_completed = StoryCollection.new @not_completed
  end

  private  
    def find_project
      Project.api_key = ProjectConfig.find_by_project_id(params[:project_id]).api_key
      @project = Project.find(params[:project_id])
    end    
end

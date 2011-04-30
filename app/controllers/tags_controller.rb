require 'story_metrics'

class TagsController < ApplicationController
  before_filter :authenticate_user!, :find_project
  
  def show
    tagged = @project.stories_with_tag params[:id]
                  
    @completed = tagged.in_archive
    
    @not_completed = tagged - @completed
    
    @tag = @project.tags.find { |t| t.id.to_s == params[:id] }
  end

  private  
    def find_project
      Project.api_key = ProjectConfig.find_by_project_id(params[:project_id]).api_key
      @project = Project.find(params[:project_id])
    end    
end

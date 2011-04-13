class TagsController < ApplicationController
  before_filter :authenticate_user!, :find_project
  
  def show
    tagged = @project.stories.find_all { |s| !s.tags.nil? && s.tags.any? { |t| t.id.to_s == params[:id] } } 
                  
    @tag = tagged.first.tags.find { |t| t.id.to_s == params[:id] } unless tagged.empty?
    
    @stories = tagged.group_by { |s| s.phase.name }    
  end

  private  
    def find_project
      @api_key = params[:api_key]
      Project.api_key = @api_key    
      @project = Project.find(params[:project_id])
    end
end

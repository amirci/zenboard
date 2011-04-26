class TagsController < ApplicationController
  before_filter :authenticate_user!, :find_project
  
  def show
    tagged = @project.stories_with_tag(params[:id])
                  
    @completed = tagged.find_all { |s| s.phase.name.downcase.include? 'archive' }
    
    @not_completed = tagged - @completed
    
    @tag = tagged.first.tags.find { |t| t.id.to_s == params[:id] } unless tagged.empty?

    @stories = tagged.group_by { |s| s.phase.name }    
    
    @monthly_summary = monthly_summary(@completed)
  end

  private  
    def find_project
      @api_key = params[:api_key]
      Project.api_key = @api_key    
      @project = Project.find(params[:project_id])
    end    
end

class TagsController < ApplicationController
  before_filter :authenticate_user!, :find_project
  
  def show
    tagged = @project.stories.find_all { |s| !s.tags.nil? && s.tags.any? { |t| t.id.to_s == params[:id] } } 
                  
    completed = tagged.find_all { |s| s.phase.name.downcase.include? 'archive' }
    
    @tag = tagged.first.tags.find { |t| t.id.to_s == params[:id] } unless tagged.empty?

    @tags = @project.stories.collect { |s| s.tags }.flatten.uniq { |t| t.id }.sort_by { |t| t.name }
    
    @stories = tagged.group_by { |s| s.phase.name }    
    
    @monthly_summary = monthly_summary(completed)
    
    @velocity = @monthly_summary.sum { |m| m.velocity } / @monthly_summary.count rescue 0
    
    @point_duration = @monthly_summary.sum { |m| m.point_duration } / @monthly_summary.count rescue 0

    @efficiency = @monthly_summary.sum { |m| m.efficiency } / @monthly_summary.count rescue 0
    
    @completed = completed.count
    
    @total = @stories.values.collect { |v| v.count }.sum
  end

  private  
    def find_project
      @api_key = params[:api_key]
      Project.api_key = @api_key    
      @project = Project.find(params[:project_id])
    end    
end

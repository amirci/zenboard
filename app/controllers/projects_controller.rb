class ProjectsController < ApplicationController

  def index
    @projects = Project.all
  end
  
  def show
    @project = Project.find(params[:id])

    @stories = Story.all_for_project(params[:id]).find_all { |s| s.phase.name == 'Archive' }.sort_by { |s| s.id }
    
    @velocity = @stories.inject(0) { |sum, story| sum + story.size.to_i }
    
    elapsed = (Time.now - @project.created_on) / (24 * 60 * 60.0)
    
    @point_duration = (@velocity / elapsed).round(2)
  end
  
end

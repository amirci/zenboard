class ProjectsController < ApplicationController

  def index
    @projects = Project.all
  end
  
  def show
    @project = Project.find(params[:id])
    @stories = Story.all_for_project(params[:id]).find_all { |s| s.phase.name == 'Archive' }.sort_by { |s| s.id }
  end
  
end

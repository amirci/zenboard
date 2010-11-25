class ProjectsController < ApplicationController

  def index
    @projects = []
    @projects << Project.all
  end
  
end

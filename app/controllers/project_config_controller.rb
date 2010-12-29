class ProjectConfigController < ApplicationController
  before_filter :find_user
  
  # Returns the collection of configured projects for current user
  def index
    @projects = @user.configurations
    @project = ProjectConfig.new
  end
  
  def create
    Project.api_key = params[:project_config][:key]
    @projects = Project.all
  end
  
  def new
    @project = ProjectConfig.create(:user => @user, :key => params[:key])
  end
  
  private 
    def find_user
      @user = User.find(params[:user_id])
    end
end

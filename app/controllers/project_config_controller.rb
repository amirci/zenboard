class ProjectConfigController < ApplicationController
  before_filter :find_user
  
  # Returns the collection of configured projects for current user
  def index
    @configurations = @user.configurations
  end
  
  def create
    @api_key = Project.api_key = params[:project_config][:key]
    @projects = Project.all
  end
  
  def new
    @config = ProjectConfig.create!(params["project"].merge!(:user => @user))
    @configurations = @user.configurations
  end
  
  private 
    def find_user
      @user = User.find(params[:user_id])
    end
end

class ProjectConfigController < ApplicationController
  before_filter :find_user
  
  # Returns the collection of configured projects for current user
  def index
  end
  
  def create
    @error = params[:project_config][:api_key].empty?
    begin
      if !@error
        @api_key = Project.api_key = params[:project_config][:api_key]
        @projects = Project.all
      else
        flash[:error]= 'Sorry, you need an api-key in order to search for projects'
      end
    rescue
      @error = true
      flash[:error]= 'Can\'t retrieve project information, make sure the key is valid'
    end  
  end
  
  def new
    flash[:notice]= 'The new project configuration has been added'
    @config = ProjectConfig.create!(params["project"].merge!(:user => @user))
    @projects = Project.all
  end
  
  private 
    def find_user
      @user = User.find(params[:user_id])
      @configurations = @user.configurations
    end
end

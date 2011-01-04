class ProjectConfigController < ApplicationController
  before_filter :find_user
  
  # Returns the collection of configured projects for current user
  def index
  end
  
  # Searches for all the projects registered under the key
  # Fails under the following conditions:
  # * No api_key present in the parameters
  # * api_key is present but empty
  # * Listing the projects raises an exception
  # In those cases the flash[:error] is set with a message
  def create
    @error = params[:api_key].nil? || params[:api_key].empty?
    begin
      if !@error
        @api_key = Project.api_key = params[:api_key]
        @projects = Project.all
      else
        flash[:error] = 'Sorry, you need an api-key in order to search for projects'
      end
    rescue
      @error = true
      flash[:error] = 'Can\'t retrieve project information, make sure the key is valid'
    end  
  end
  
  # Creates a new configuration
  def new
    flash[:notice] = 'The new project configuration has been added'
    @current_config = ProjectConfig.create!(params["project"].merge!(:user => @user))
    @projects = Project.all
    @api_key = params['project']['api_key']
  end
  
  # Deletes the configuration indicated by the id
  def destroy
    project = ProjectConfig.find(params[:id])
    project.destroy
    @configurations = @user.configurations
  end
  
  private 
    # Finds the user that matches the user_id in the parameters
    def find_user
      @user = User.find(params[:user_id])
      @configurations = @user.configurations
    end
end

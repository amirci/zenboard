require "api_key_missing_error"

class ProjectConfigController < ApplicationController
  before_filter :authenticate_user!, :find_user
  before_filter :find_configurations, :except => [:new, :destroy]
  
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
    find_projects(params[:api_key])
  end
  
  # Creates a new configuration
  def new
    @current_config = ProjectConfig.create!(params["project"].merge!(:user => @user))
    find_projects(params['project']['api_key'])
    flash.now[:notice] = "The new configuration #{@current_config.name} has been added"
    find_configurations
  end
  
  # Deletes the configuration indicated by the id
  def destroy
    project = ProjectConfig.find(params[:id])
    flash.now[:notice] = "The project #{project.name} has been removed from the configuration"
    project.destroy
    find_configurations
  end
  
  private 
    # Finds the user that matches the user_id in the parameters
    def find_user
      @user = User.find(params[:user_id])
    end
    
    # Find the projects associated to the api key
    def find_projects(api_key, error_msg = 'Sorry, you need an api-key in order to search for projects')
      if api_key.nil? || api_key.empty?
        flash.now[:error] = error_msg if error_msg
        raise ApiKeyMissingError 
      end
      @api_key = Project.api_key = api_key
      @projects = Project.all
    end

    # Calculate the user configuration and a hash by key
    def find_configurations
      @configurations = @user.configurations
      @config_by_key = @configurations.inject({}) do |map, cfg|
        values = map[cfg.api_key] || []
        values << cfg
        map[cfg.api_key] = values
        map
      end
    end
end

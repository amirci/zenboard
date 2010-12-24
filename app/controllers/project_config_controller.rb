class ProjectConfigController < ApplicationController

  # Returns the collection of configured projects for current user
  def index
    @projects = find_user.projects_config
  end

  private 
    def find_user
      User.find(:user_id => params[:user_id])
    end
end

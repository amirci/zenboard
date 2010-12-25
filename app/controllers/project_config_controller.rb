class ProjectConfigController < ApplicationController
  before_filter :find_user
  
  # Returns the collection of configured projects for current user
  def index
    @projects = @user.configurations
  end

  private 
    def find_user
      @user = User.find(params[:user_id])
    end
end

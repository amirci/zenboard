class HomeController < ApplicationController
  
  def index
    @projects = current_user.configurations if current_user
  end
end

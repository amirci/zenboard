class HomeController < ApplicationController
  
  def index
    @projects = KfuProject.all
  end
end

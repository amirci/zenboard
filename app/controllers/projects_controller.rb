require 'active_resource'
require 'ostruct'

class ProjectsController < ApplicationController
  before_filter :authenticate_user!, :find_project

  # Show the details of a project
  def show
    @months = monthly_summary(@project.stories.in_archive)
    
    @month_filter = params[:month]
    
    @byweek = weekly_summary_for(params[:month])
  end

  private
    def find_project
      Project.api_key = ProjectConfig.find_by_project_id(params[:id]).api_key
      @project = Project.find(params[:id])
    end
  
    def weekly_summary_for(month)
      
      date = DateTime.parse(month) rescue DateTime.now
      
      weeks = month.nil? ? Week.previous(5) : Week.in_month(date)

      # map to the actual week
      # remove older stories (couldn't find them in weeks collection)
      @project.stories_in_archive                                                \
              .find_all  { |s| month.nil? || (s.finished_on.month == date.month && s.finished_on.year == date.year) } \
              .group_by  { |s| weeks.find { |w| w.include? s.finished_on } }     \
              .delete_if { |k, v| k.nil? }
    end
end

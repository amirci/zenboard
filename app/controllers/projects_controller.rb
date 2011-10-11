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
      @project = KfuProject.all.select { |p| p.id == params[:id].to_i }.first
    end
  
    def weekly_summary_for(month)
      
      date = DateTime.parse(month) rescue DateTime.now
      
      weeks = month.nil? ? Week.previous(5) : Week.in_month(date)

      # map to the actual week
      # remove older stories (couldn't find them in weeks collection)
      s = @project.
            stories_in_archive.
            find_all  { |s| that_finished_on_same_month(s, month, date) }.
            group_by  { |s| finish_week(s, weeks) }.
            delete_if { |k, v| k.nil? }
    end
    
    def week_not_found(k, v)
      k.nil?
    end
    
    def that_finished_on_same_month(s, month, date)
      month.nil? || (s.finished_on.month == date.month && s.finished_on.year == date.year)
    end
    
    def finish_week(s, weeks)
      weeks.find {|w| w.include? s.finished_on }
    end
end

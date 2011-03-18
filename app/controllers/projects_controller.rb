require 'active_resource'
require 'ostruct'

class ProjectsController < ApplicationController
  before_filter :authenticate_user!, :find_project

  # Show the details of a project
  def show
    @months = monthly_summary
    
    @velocity = @months.sum { |m| m.velocity } / @months.count 

    @point_duration = @months.sum { |m| m.point_duration } / @months.count 

    @byweek = weekly_summary(5)
    
    @efficiency = @months.sum { |m| m.efficiency } / @months.count
  end

  private
    def find_project
      Project.api_key = params[:api_key]    
      @project = Project.find(params[:id])
    end
    
    def monthly_summary
      # map to year and month
      # Create structures to represent the month summary
      @project.stories_in_archive                              \
              .group_by { |s| s.finished_on.strftime('%Y%m') } \
              .collect { |k, v| create_month(k, v) }           \
              .sort_by { |m| m.date }                          \
              .reverse 
    end

    def weekly_summary(how_many)
      weeks = Week.previous(how_many)

      # map to the actual week
      # remove older stories (couldn't find them in weeks collection)
      @project.stories_in_archive                                           \
              .group_by { |s| weeks.find { |w| w.include? s.finished_on } } \
              .delete_if { |k, v| k.nil? }
    end

    def create_month(year_month, stories)
      month = OpenStruct.new 
      month.date = Date.parse(year_month + '01')
      month.velocity = stories.sum { |s| s.size.to_i } 
      month.point_duration = (30.0 / month.velocity).round(2) 
      month.stories = stories.count
      month.blocked = stories.sum(&:blocked_time) 
      month.waiting = stories.sum(&:waiting_time) 
      month.efficiency = stories.sum(&:efficiency) / stories.count
      month
    end
end

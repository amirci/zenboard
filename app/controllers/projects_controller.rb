require 'active_resource'
require 'ostruct'

class ProjectsController < ApplicationController
  before_filter :authenticate_user!, :find_project

  # Show the details of a project
  def show
    bymonth = @project.stories_in_archive.inject({}) do |h, story| 
      key = story.finished_on.strftime('%Y%m')
      h[key] = [] unless h.key? key
      h[key] << story
      h
    end
    
    @months = bymonth.each_pair.collect { |k, v| create_month(k, v) }.sort_by { |m| m.date }.reverse rescue []
    
    @velocity = @months.sum { |m| m.velocity } / @months.count rescue 0.0

    @point_duration = @months.sum { |m| m.point_duration } / @months.count rescue 0.0
    
    weeks = Week.previous(5)
    
    @byweek = @project.stories_in_archive.inject({}) do |h, story| 
      key = weeks.find { |w| w.include? story.finished_on }
      h[key] = [] unless h.key? key
      h[key] << story
      h
    end

    # remove older stories
    @byweek.delete nil
  end

  private
    def find_project
      Project.api_key = params[:api_key]    
      @project = Project.find(params[:id])
    end
    
    def create_month(year_month, stories)
      month = OpenStruct.new 
      month.date = Date.parse(year_month + '01')
      month.velocity = stories.sum { |s| s.size.to_i } 
      month.point_duration = (30.0 / month.velocity).round(2) rescue 0
      month.stories = stories.count
      month.blocked = stories.sum(&:blocked_time) 
      month.waiting = stories.sum(&:waiting_time) 
      month.efficiency = stories.sum(&:efficiency) / stories.count
      month
    end
end

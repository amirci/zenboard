require 'active_resource'

class ProjectsController < ApplicationController

#  rescue_from(Exception) { |e| render :file => '/not_authorized' }
#  rescue_from(Exception) { |e| render :file => '/shoot', :text => e.message }

  def index
    @projects = Project.all
  end
  
  def show
    @project = Project.find(params[:id])

    @project.stories
    
    bymonth = @project.archived.inject({}) do |h, story| 
      key = story.finished_on.strftime('%Y%m')
      h[key] = [] unless h.key? key
      h[key] << story
      h
    end
    
    @months = bymonth.each_pair.collect { |k, v| Month.new(k, v) } rescue {}
          
    @velocity = @months.sum { |m| m.velocity } / @months.count rescue 0.0

    @point_duration = @months.sum { |m| m.point_duration } / @months.count rescue 0.0
    
    weeks = Week.previous(5)
    
    @byweek = @project.archived.inject({}) do |h, story| 
      key = weeks.find { |w| w.include? story.finished_on }
      h[key] = [] unless h.key? key
      h[key] << story
      h
    end

    # remove older stories
    @byweek.delete nil
  end

  class Month
    attr_reader :name, :velocity, :point_duration, :year, :stories
    attr_reader :blocked, :waiting, :efficiency
    
    def initialize(year_month, stories)
      @velocity = stories.sum { |s| s.size.to_i }
      @point_duration = stories.sum(&:point_duration) / 30
      date = Date.parse(year_month + '01')
      @year = date.strftime('%Y')
      @name = date.strftime('%b')
      @stories = stories.count
      @blocked = stories.sum(&:blocked_time) 
      @waiting = stories.sum(&:waiting_time) 
      @efficiency = stories.sum(&:efficiency) / stories.count
    end
  end
end

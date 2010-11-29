class ProjectsController < ApplicationController

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
    
    @months = bymonth.each_pair.collect { |k, v| Month.new(k, v) }
          
    @velocity = @months.sum { |m| m.velocity } / @months.count

    @point_duration = @months.sum { |m| m.point_duration } / @months.count
  end

  class Month
    attr_reader :name, :velocity, :point_duration, :year, :stories
    
    def initialize(year_month, stories)
      @velocity = stories.sum { |s| s.size.to_i }
      @point_duration = stories.sum(&:point_duration) / stories.count
      date = Date.parse(year_month + '01')
      @year = date.strftime('%Y')
      @name = date.strftime('%b')
      @stories = stories.count
    end
  end
end

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
    
    last_week = Week.new(Chronic.parse('last monday'))
    
    weeks = [last_week, last_week.previous, last_week.previous.previous]
    
    @byweek = @project.archived.inject({}) do |h, story| 
      key = weeks.find { |w| w.include? story.finished_on }
      h[key] = [] unless h.key? key
      h[key] << story
      h
    end

    @byweek.delete nil
  end

  class Week
    attr_reader :start, :finish
    
    def initialize(start)
      @start = start
      @finish = start + 6 * 24 * 60 * 60
    end
    
    # Checks a date is included in the week
    def include?(date)
      date >= start && date <= finish
    end
    
    def previous
      Week.new(start - 6 * 24 * 60 * 60)
    end
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

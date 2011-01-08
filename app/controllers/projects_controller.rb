require 'active_resource'

class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  
  rescue_from(Exception)  do |ex| 
    logger.error ex
    logger.error ex.class
    logger.error ex.backtrace.join("\n")
    render :file => '/not_authorized' 
  end
    
  #  rescue_from(Exception) { |e| render :file => '/shoot', :text => e.message }

  # Show the details of a project
  def show
    Project.api_key = params[:api_key]    

    retried = false
    
    begin
      @project = Project.find(params[:id])
    rescue ActiveResource::Redirection => ex
      location = ex.response['Location']
      logger.error "Exception getting project detail, should redirect to #{location}"
      unless retried
        logger.error "Should redirect to #{location.include? 'https:'}"
        Project.switch_https(location.include? 'https:')
        logger.error "Switching url to #{Project.site}"
        retried = true and retry # retry operation
      end
    end      

    # load the stories
    @project.load_stories
    
    bymonth = @project.archived.inject({}) do |h, story| 
      key = story.finished_on.strftime('%Y%m')
      h[key] = [] unless h.key? key
      h[key] << story
      h
    end

    begin
      @months = bymonth.each_pair.collect { |k, v| Month.new(k, v) }.reverse
    rescue
      logger.error ex
      logger.error ex.class
      logger.error ex.backtrace.join("\n")
      @months = {} 
    end
          
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
      @point_duration = stories.sum(&:point_duration) / 30.0
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

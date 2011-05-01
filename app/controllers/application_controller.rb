require 'story_metrics'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from Exception, :with => :not_authorized

  rescue_from(ApiKeyMissingError) do |ex|
    @error = true
    logger.error "Api Key Missing!, rendering to #{params[:action]}"
    render params[:action]
  end

  private
    def not_authorized(ex)
      log_exception(ex)
      @error = true
      flash.now[:error] = 'Can\'t retrieve project information, make sure the key is valid' unless flash.now[:error]
      render :file => '/not_authorized' 
    end
  
    def log_exception(ex)
      logger.error ex
      logger.error ex.class
      logger.error ex.backtrace.join("\n")
    end    
    
    def monthly_summary(stories)
      # map to year and month
      # Create structures to represent the month summary
      stories                                               \
          .group_by { |s| s.finished_on.strftime('%Y%m') }  \
          .collect { |k, v| create_month(k, v) }            \
          .sort_by { |m| m.date }                          \
          .reverse
    end    

    def create_month(year_month, stories)
      month = OpenStruct.new 
      month.actual_stories = stories
      month.date = Date.parse(year_month + '01')
      month.velocity = stories.points
      month.point_duration = stories.points / 20.0
      month.efficiency = stories.efficiency
      month.stories = stories.count
      month.blocked = stories.sum(&:blocked_time) 
      month.waiting = stories.sum(&:waiting_time) 
      month
    end    
end

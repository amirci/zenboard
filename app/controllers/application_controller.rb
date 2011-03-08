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
end

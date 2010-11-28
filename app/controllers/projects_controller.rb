class ProjectsController < ApplicationController

  def index
    @projects = Project.all
  end
  
  def show
    @project = Project.find(params[:id])

    archived = @project.stories.find_all { |s| s.phase.name == 'Archive' }
    
    @stories = archived.sort_by { |s| s.id }
    
    @velocity = @stories.inject(0) { |sum, story| sum + story.size.to_i }
    
    elapsed = (Time.now - @project.created_on) / (24 * 60 * 60.0)
    
    @point_duration = (@velocity / elapsed).round(2)
    
    bymonth = archived.inject({}) { |h, story| h[story.finished_on.month] = story }
    
    @months = [Month.new('Jan', 10, 10) ]
  end

  class Month
    attr_reader :name, :velocity, :point_duration
    
    def initialize(n, v, p)
      @name = n
      @velocity = v
      @point_duration = p
    end
  end
end

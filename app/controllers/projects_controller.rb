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
    
    @months = bymonth.keys.collect do |key|
      vel = bymonth[key].sum { |s| s.size.to_i }
      pd = bymonth[key].sum(&:point_duration) / bymonth[key].count
      date = Date.parse(key + '01')
      year = date.strftime('%Y')
      month = date.strftime('%b')
      Month.new(year, month, vel.round, pd.round(2))
    end
          
    @velocity = @months.sum { |m| m.velocity } / @months.count
    @point_duration = @months.sum { |m| m.point_duration } / @months.count
  end

  class Month
    attr_reader :name, :velocity, :point_duration, :year
    
    def initialize(y, n, v, p)
      @year = y
      @name = n
      @velocity = v
      @point_duration = p
    end
  end
end

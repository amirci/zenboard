class StoryCollection
  include Enumerable
  extend Forwardable
  
  attr_reader :stories
  
  def_delegator :@stories, :empty?
  
  def initialize(stories)
    @stories = stories
  end

  # Enumerable implementation
  def each(&block)
    @stories.each(&block)
  end
  
  def points
    @stories.sum { |s| s.size.to_i }
  end
  
  def velocity
    points.to_f / count
  end
  
  def started_on
    @stories.min_by(&:started_on).started_on
  end
  
  def completed_on
    @stories.max_by(&:finished_on).finished_on
  end
  
  def duration
    completed_on - started_on
  end
  
  def point_duration
    points.to_f / duration
  end
  
  def +(collection)
    collection = collection.stories if collection.kind_of? StoryCollection
    StoryCollection.new(@stories + collection)
  end
  
end
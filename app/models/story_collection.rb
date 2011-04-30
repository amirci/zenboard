class StoryCollection
  include StoryMetrics
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
    
  def +(collection)
    collection = collection.stories if collection.kind_of? StoryCollection
    StoryCollection.new(@stories + collection)
  end
  
end


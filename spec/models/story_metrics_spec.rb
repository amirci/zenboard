require 'spec_helper'

describe StoryMetrics do

  before(:each) do
    story1 = double("Story1", :size => 8, :started_on => Date.today - 30, :finished_on => Date.today - 5)

    story2 = double("Story2", :size => 3, :started_on => Date.today - 20, :finished_on => Date.today)
    
    class Impl 
      include StoryMetrics
      
      attr_reader :stories
      
      def initialize(stories)
        @stories = stories
      end
    end
    
    @stories = Impl.new([story1, story2])
  end
  
  it "should calculate points" do
    @stories.points.should == 11
  end
  
  it "should calculate started on" do
    @stories.started_on.should == Date.today - 30
  end

  it "should calculate completed on" do
    @stories.completed_on.should == Date.today
  end
  
  it "should calculate duration" do
    @stories.duration.should == 30
  end
  
  it "should return velocity" do
    @stories.velocity.should == 11 / Week.since(@stories.started_on).count.to_f
  end
  
  it "should calculate point duration" do
    @stories.point_duration.should == 11 / 30.0
  end
  
end
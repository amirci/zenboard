require 'spec_helper'

describe StoryCollection do

  before(:each) do
    story1 = double("Story1", :size => 8, :started_on => Date.today - 30, :finished_on => Date.today - 5)

    story2 = double("Story2", :size => 3, :started_on => Date.today - 20, :finished_on => Date.today)

    @stories = StoryCollection.new([story1, story2])
  end
  
  it "should calculate points" do
    @stories.points.should == 11
  end
  
  it "should return velocity" do
    @stories.velocity.should == 11 / 2.0
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
  
  it "should calculate point duration" do
    @stories.point_duration.should == 11 / 30.0
  end
  
  it "should calculate empty" do
    @stories.empty?.should be_false
  end
  
  it "should concatenate two collections" do
    story = double("Story3", :size => 8, :started_on => Date.today - 20)
    c2 = StoryCollection.new [story]
    (@stories + c2).count.should == 3
  end
end
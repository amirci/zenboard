require 'spec_helper'

describe StoryCollection do

  before(:each) do
    story1 = double("Story1")
    story1.stub(:size).and_return(3)
    story1.stub(:started_on).and_return(Date.today - 30)
    story1.stub(:finished_on).and_return(Date.today - 5)

    story2 = double("Story2")
    story2.stub(:size).and_return(8)
    story2.stub(:started_on).and_return(Date.today - 20)
    story2.stub(:finished_on).and_return(Date.today)

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
  
end
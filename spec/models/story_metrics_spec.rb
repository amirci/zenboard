require 'spec_helper'

describe StoryMetrics do

  before(:each) do
    archive = double("Phase", :name => 'archive')
    
    working = double("Phase Working", :name => 'working')
    
    story1 = double("Story1", :phase => archive, :size => 8, :efficiency => 40,
                              :started_on => Date.today - 30, :finished_on => Date.today - 5);

    story2 = double("Story2", :phase => working, :size => 3, :efficiency => 80,
                              :started_on => Date.today - 20, :finished_on => Date.today);
    
    @stories = [story1, story2]
  end
  
  it "should calculate points" do
    @stories.points.should == 11
  end
  
  it "should calculate efficiency" do
    @stories << double("Story3", :efficiency => nil)
    @stories.efficiency.should == 60
  end

  it "should calculate started on" do
    @stories.started_on.should == Date.today - 30
  end

  it "should calculate started on also with unfinished tasks" do
    @stories << double("Story4", :started_on => nil, :finished_on => nil)
    @stories.started_on.should == Date.today - 30
  end

  it "should calculate completed on" do
    @stories.completed_on.should == Date.today
  end
  
  it "should calculate duration" do
    @stories.duration.should == 30
  end

  it "should calculate duration also with unfinished tasks" do
    @stories << double("Story4", :started_on => Date.today - 10, :finished_on => nil)
    @stories.duration.should == 30
  end
  
  it "should return velocity" do
    @stories.velocity.should == 11 / Week.since(@stories.started_on).count.to_f
  end
  
  it "should calculate point duration" do
    # 30 days - weekends
    @stories.point_duration.should == 11.0 / (30 - Week.since(@stories.started_on).count * 2)
  end
  
  it "should filter stories by phase" do
    @stories.in_archive.should == @stories.find_all { |s| s.phase.name.downcase.include? 'archive' }
  end
end
require 'spec_helper'
require 'fakeweb'
require 'json'

describe Project do

  # Setup responses for projects, project and stories
  before(:each) do
    archive = Phase.make(:archive)
    working = Phase.make(:working)
    
    @owner = Owner.make(:name => "Lorenzo Valdez")
    
    @project = Project.make(:owner => @owner)
        
    projects_response = JSON.generate( { "page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 1, "items" => [@project.to_hash]})

    FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/projects", :body => projects_response)
    
    FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/project/#{@project.id}", :body => JSON.generate(@project.to_hash))

    finished = JSONHelper::Date.to_json(Chronic.parse('today'))
    started = JSONHelper::Date.to_json(Chronic.parse('6 days ago'))
    
    @story = Story.make(:phase => archive, :size => 3, :metrics => Metrics.make(:startTime => started, :finishTime => finished))

    @story2 = Story.make(:phase => working, :size => 8)
    
    stories = [@story.to_hash, @story2.to_hash]
    
    stories_response = JSON.generate( { "page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 1, "items" => stories})
    
    FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/project/#{@project.id}/stories?with=metrics&pageSize=1000", :body => stories_response)
  end
  
  # Checks when calling all the project is returned
  it "Should return the projects from site" do
    projects = Project.all
    
    projects.count.should == 1

    project = projects.first

    project.should == @project
    project.created_on.should == Time.at(@project.createTime[6, 10].to_i)
    project.owner.should == @owner
  end
  
  # Check the detail of the project, the stories and calculated metrics
  it "Should return the project with id matching" do
    # project check
    found = Project.find(@project.id)
    found.should == @project

    # stories check
    stories = found.stories
    stories.should == [@story, @story2]

    # Calculations based on stories
    found.velocity.should == @story.size
    found.throughput.should == 1
    found.point_duration.should == @story.point_duration
  end  
end

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

    FakeWeb.register_uri(:get, "https://agilezen.com/api/v1/projects.json", :body => projects_response)
    
    FakeWeb.register_uri(:get, "https://agilezen.com/api/v1/projects/#{@project.id}.json", :body => JSON.generate(@project.to_hash))

    finished = Chronic.parse('today').strftime('%FT%T%z')
    started = Chronic.parse('6 days ago').strftime('%FT%T%z')
    
    @story = Story.make(:phase => archive, :size => 3, :metrics => Metrics.make(:startTime => started, :finishTime => finished))

    @story2 = Story.make(:phase => working, :size => 8)
    
    stories = [@story.to_hash, @story2.to_hash]
    
    Project.stub!(:api_key).and_return("aaa")
  end
  
  # Checks when calling all the project is returned
  it "Should return the projects from site" do
    projects = Project.all
    projects.should == [@project]
  end
  
  # Check the detail of the project, the stories and calculated metrics
  it "Should return the project with id matching" do
    # project check
    found = Project.find(@project.id)
    found.should == @project
  end  
  
  it "Should return the stories for the project" do
    Story.should_receive(:all_for_project).with(@project.id, "aaa").and_return([@story, @story2])
    
    found = Project.find(@project.id)

    # stories check
    found.stories.should == [@story, @story2]
  end
  
  it "Should return stories by phase" do
    Story.should_receive(:all_for_project).with(@project.id, "aaa").and_return([@story, @story2])
    found = Project.find(@project.id)
    found.stories_in_archive.should == [@story]
  end
end

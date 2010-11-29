require 'spec_helper'
require 'fakeweb'
require 'json'

describe Project do

  # Setup responses for projects, project and stories
  before(:each) do
    archive = Phase.make(:archive)
    
    @project = Project.make()
        
    projects_response = JSON.generate( { "page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 1, "items" => [@project.to_hash]})

    FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/projects", :body => projects_response)
    
    FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/project/#{@project.id}", :body => JSON.generate(@project.to_hash))

    @story = Story.make(:phase => archive)
    
    stories_response = JSON.generate( { "page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 1, "items" => [@story.to_hash]})
    
    FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/project/#{@project.id}/stories?with=metrics&pageSize=1000", :body => stories_response)
    
  end
  
  # Checks when calling all the project is returned
  it "Should return the projects from site" do
    projects = Project.all
    
    projects.should_not be_empty

    projects.first.should == @project
  end
  
  # Check the detail of the project, the stories and calculated metrics
  it "Should return the project with id matching" do
    # project check
    found = Project.find(@project.id)
    found.should == @project

    # stories check
    stories = found.stories
    stories.count.should == 1
    stories.first.should == @story    

    # Calculations based on stories
    found.velocity.should == stories.inject(0) { |sum, s| sum += s.size }
    found.throughput.should == stories.count
  end  
end

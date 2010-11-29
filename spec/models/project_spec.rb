require 'spec_helper'
require 'fakeweb'
require 'json'

describe Project do

  it "Should return the projects from site" do
    project = Project.make(:id => 44, :name => "Rails First Project")
        
    fake_response = JSON.generate( { "page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 1, "items" => [project.to_hash]})

    FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/projects", :body => fake_response)

    projects = Project.all
    
    projects.should_not be_empty
    projects.first.should == project
  end
  
  it "Should return the project with id matching" do

    project = Project.make(:id => 44)
    
    FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/project/44", :body => JSON.generate(project.to_hash))

    story = Story.make
    
    stories_response = JSON.generate( { "page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 1, "items" => [story.to_hash]})
    
    FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/project/44/stories?with=metrics&pageSize=1000", :body => stories_response)
    
    found = Project.find(44)
    
    found.should == project

    found.velocity.should == 2

    stories = project.stories
    
    stories.count.should == 1
    
    stories.first.should == story
    
  end
  
end

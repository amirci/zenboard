require 'spec_helper'
require 'fakeweb'
require 'json'

describe ProjectsController do

  it "Should obtain all projects" do
    project = {"id" => 4444,
        "name" => "Rails First Project",
        "description" => "Project developed in rails",
        "createTime" => "\/Date(1256774726000-0500)\/",
        "owner" => {"id" => 2222,"name" => "John Spec"}}
        
    fake_response = JSON.generate( { "page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 6, "items" => [project]})

    FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/projects", :body => fake_response)

    get :index
    
    response.should be_success
    assigns("projects").should_not be_empty
    assigns("projects").first.name.should == "Rails First Project"
  end
  
  it "Should obtain details of a project" do
    project = {"id" => 4444,
        "name" => "Rails First Project",
        "description" => "Project developed in rails",
        "createTime" => "\/Date(1256774726000-0500)\/",
        "owner" => {"id" => 2222,"name" => "Amir Barylko"}}
        
    story = {"id" => 1, 
      "text" => "End world hunger", "size" => 3, "color" => "gray", "ready" => true, "blocked" => false,
      "reasonBlocked" => "new ideas", "phase" => { "id" => 1, "name" => "Archive"}, "phaseIndex" => 0,
      "creator" => { "id" => 1, "name" => "John Doe"}, "owner" => {"id" => 2222,"name" => "John Spec"},
      "metrics" => { "createdTime" => "\/Date(1256774726000-0500)\/", "startTime" => "\/Date(1256774726000-0500)\/" }
       }

    fake_response = JSON.generate( { "page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 6, "items" => [story]})

    FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/project/4444", :body => JSON.generate(project))
    
    FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/project/4444/stories?with=metrics", :body => fake_response)

    get :show, { :id => 4444 }
    
    response.should be_success

    assigns("project").name.should == "Rails First Project"
    assigns("stories").should_not be_empty
  end
  
end

require 'spec_helper'
require 'fakeweb'
require 'json'

describe ProjectsController do

  it "Should obtain all projects" do
    project = {"id" => 4444,
        "name" => "Rails First Project",
        "description" => "Project developed in rails",
        "createTime" => "\/Date(1256774726000-0500)\/",
        "owner" => {"id" => 2222,"name" => "Amir Barylko"}}
        
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
        
    fake_response = JSON.generate(project)

    FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/projects/4444", :body => fake_response)

    get :show, { :id => 4444 }
    
    response.should be_success
    assigns("project").should_not be_empty
    assigns("project").name.should == "Rails First Project"
  end
  
end

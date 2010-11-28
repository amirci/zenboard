require 'spec_helper'
require 'fakeweb'
require 'json'

describe Project do

  it "Should return the projects from site" do
    project = {"id" => 4444,
        "name" => "Rails First Project",
        "description" => "Project developed in rails",
        "createTime" => "\/Date(1256774726000-0500)\/",
        "owner" => {"id" => 2222,"name" => "John Spec"}}
        
    fake_response = JSON.generate( { "page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 6, "items" => [project]})

    FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/projects", :body => fake_response)

    projects = Project.all
    
    projects.should_not be_empty
    projects.first.name.should == "Rails First Project"
  end
  
  it "Should return the project with id matching" do
    pending "Not yet implemented"
  end
  
end

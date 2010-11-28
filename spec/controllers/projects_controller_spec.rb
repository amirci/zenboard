require 'spec_helper'

describe ProjectsController do

  it "Should obtain all projects" do
    project = Project.make(:id => 44, :name => "Rails First Project")

    Project.stub!(:all).and_return([project])
        
    get :index
    
    response.should be_success
    assigns("projects").should_not be_empty
    assigns("projects").first.name.should == "Rails First Project"
  end
  
  it "Should obtain details of a project" do
    ten_days_ago = Chronic.parse("10 days ago")
    
    project = Project.make(:id => 44, :name => "Rails First Project", :createTime => "\/Date(#{ten_days_ago.to_i}000-0500)\/")
       
    story = Story.make(:size => 10)
     
    Project.stub!(:find).and_return(project)
    
    project.stub!(:stories).and_return([story])

    get :show, { :id => 4444 }
    
    response.should be_success

    assigns("project").name.should == "Rails First Project"
    assigns("stories").should_not be_empty
    assigns("velocity").should == 10
    assigns("point_duration").should == 1
  end
  
end

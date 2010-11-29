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
    ten_days_ago = JSONHelper::Date.to_json(Chronic.parse("10 days ago"))
    
    project = Project.make(:id => 44, 
                           :name => "Rails First Project", 
                           :createTime => ten_days_ago)
       
    story = Story.make(:size => 10)
     
    Project.stub!(:find).and_return(project)
    
    project.stub!(:stories).and_return([story])
    project.stub!(:archived).and_return([story])

    get :show, { :id => 4444 }
    
    response.should be_success

    assigns("project").should == project
  end
  
end

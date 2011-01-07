require 'spec_helper'
require 'devise/test_helpers'

describe ProjectsController do
  include Devise::TestHelpers

  # Gets the detail of a project  
  it "Should obtain details of a project" do
    project = double("Project")       
    story = double("Story")  
    story.stub!(:finished_on).and_return(DateTime.now)
    story.stub!(:size).and_return(3)
    story.stub!(:point_duration).and_return(0.5)
    story.stub!(:blocked_time).and_return(0.2)
    story.stub!(:waiting_time).and_return(0.2)
    story.stub!(:efficiency).and_return(0.2)
       
    Project.should_receive(:api_key=).with("aaa")
    Project.stub!(:find).with(44).and_return(project)    
    project.stub!(:stories).and_return([story])
    project.stub!(:archived).and_return([story])

    user = User.make()
    user.confirm!
    user.save!
    sign_in :user, user
    
    get :show, { :id => 44, :api_key => "aaa" }
    
    response.should be_success
    response.should render_template "show"
    assigns[:project].should == project
  end
  
end

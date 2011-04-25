require 'spec_helper'
require 'devise/test_helpers'

describe ProjectsController do
  include Devise::TestHelpers

  before(:each) do
    @project = double("Project")       
    Project.should_receive(:api_key=).with("aaa")
    Project.stub!(:find).with(44).and_return(@project)    

    user = User.make()
    user.confirm!
    user.save!
    sign_in :user, user
  end
  
  it "should return everything zero if no archived stories were found" do
    @project.stub!(:stories).and_return([double("Story")])
    @project.stub!(:stories_in_archive).and_return([])

    get :show, { :id => 44, :api_key => "aaa" }
    
    response.should be_success
    response.should render_template "show"
    assigns[:project].should == @project
    assigns[:months].should be_empty
    assigns[:byweek].should be_empty
    assigns[:month_filter].should be_nil
  end
  
  # Gets the detail of a project  
  it "Should obtain details of a project" do
    story = double("Story")  
    story.stub!(:finished_on).and_return(DateTime.now)
    story.stub!(:size).and_return(3)
    story.stub!(:point_duration).and_return(0.5)
    story.stub!(:blocked_time).and_return(0.2)
    story.stub!(:waiting_time).and_return(0.2)
    story.stub!(:efficiency).and_return(0.2)
       
    @project.stub!(:stories).and_return([story])
    @project.stub!(:stories_in_archive).and_return([story])
    
    get :show, { :id => 44, :api_key => "aaa" }
    
    response.should be_success
    response.should render_template "show"
    assigns[:project].should == @project
    assigns[:months].should_not == nil
    assigns[:byweek].should_not == nil
  end
  
end

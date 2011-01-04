require 'spec_helper'
require "devise/test_helpers" 

describe ProjectConfigController do

  # Setup the user and the associated projects
  before(:each) do
    @user = double("MockUser")
    @projects = []
    10.times{ @projects << ProjectConfig.make }

    @user.stub!(:id).and_return(1)
    @user.stub!(:configurations).and_return(@projects)
    User.should_receive(:find).with(@user.id).and_return(@user)
  end
  
  # Index action
  it "should list all the projects config" do
    get :index, :user_id => @user.id
    response.should be_success
    assigns[:configurations].should == @projects
  end

  # Searches for projects to add
  it "Should search for projects matching api" do
    projects = []
    10.times { |i| projects << double("project_#{i}") }
    Project.stub!(:all).and_return(projects)
    Project.should_receive(:api_key=).with("aaa")
    get :create, :user_id => @user.id, :api_key => "aaa"
    assigns("projects").should == projects
    assigns[:api_key].should == "aaa"
  end
  
  it "Should fail to search if api key is empty" do
    get :create, :user_id => @user.id, :api_key => ""
    flash[:error].should == "Sorry, you need an api-key in order to search for projects"
  end

  it "Should fail to search if api key is not present" do
    get :create, :user_id => @user.id
    flash[:error].should == "Sorry, you need an api-key in order to search for projects"
  end
    
  it "Should fail to search if api key is invalid" do
    Project.stub!(:all).and_raise("Invalid api key")
    Project.should_receive(:api_key=).with("aaa")
    get :create, :user_id => @user.id, :api_key => "aaa"
    flash[:error].should == 'Can\'t retrieve project information, make sure the key is valid'
  end

  # New action
  it "Should create a new configuration" do
    project = {"project_id" => '1', "name" => 'Project', "api_key" => 'aaa'}
    ProjectConfig.should_receive(:create!).with(project.merge("user" => @user))
    get :new, :user_id => @user.id, :project => project
    flash[:notice].should == 'The new project configuration has been added'
  end
        
  # Destroy action
  it "Should remove the configuration" do
    project = @projects.first
    project.should_receive(:destroy)
    ProjectConfig.stub!(:find).with(project.id).and_return(project)    
    @projects.delete(project)
    @user.stub!(:configurations).and_return(@projects)
    get :destroy, :user_id => @user.id, :id => project.id
    response.should be_success
    assigns("configurations").should == @projects
  end
  
end

require 'spec_helper'

describe ProjectConfigController do

  # Setup the user and the associated projects
  before(:each) do
    @user = double("MockUser")
    
    @configurations = (1..10).inject([]) do |a, i| 
      config = double("ProjectConfig_#{i}")
      config.stub!(:api_key).and_return("aaa")
      a << config
    end

    @user.stub!(:id).and_return(1)
    @user.stub!(:configurations).and_return(@configurations)
    User.should_receive(:find).with(@user.id).and_return(@user)

    @projects = (1..10).inject([]) { |a, i| a << double("project_#{i}") }
    Project.stub!(:all).and_return(@projects)
  end
  
  # Index action
  it "should list all the projects config" do
    get :index, :user_id => @user.id
    
    response.should be_success
    assigns[:configurations].should == @configurations
  end

  # Searches for projects to add
  it "Should search for projects matching api" do
    Project.should_receive(:api_key=).with("aaa")

    get :create, :user_id => @user.id, :api_key => "aaa"
    
    response.should be_success
    assigns[:projects].should == @projects
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
    config = {"name" => "NewConfig", "project_id" => 1, "api_key" => "aaa"}.merge("user" => @user)
    Project.should_receive(:api_key=).with("aaa")
    ProjectConfig.should_receive(:create!).with(config)
    
    get :new, :user_id => @user.id, :project => config
    
    flash[:notice].should == 'The new project configuration has been added'
    assigns[:api_key].should == 'aaa'
    assigns[:configurations].should == @configurations
    assigns[:projects].should == @projects 
  end
        
  # Destroy action
  it "Should remove the configuration" do
    config = @configurations.first
    config.should_receive(:destroy)
    ProjectConfig.stub!(:find).with(config.id).and_return(config)    
    @projects.delete(config)
    
    get :destroy, :user_id => @user.id, :id => config.id
    
    response.should be_success
    assigns[:configurations].should == @configurations
  end
  
end

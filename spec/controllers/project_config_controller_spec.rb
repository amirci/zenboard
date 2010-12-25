require 'spec_helper'
require "devise/test_helpers" 

describe ProjectConfigController do
  include Devise::TestHelpers
  
  it "should list all the projects config" do
    projects = 10.times{ ProjectConfig.make }

    @user = User.make()

    @controller.stub!(:current_user).and_return(@user)

    User.stub!(:find).with(@user.id).and_return(@user)

    @user.stub!(:configurations).and_return(projects)

    get :index, :user_id => @user.id

    response.should be_success

    assigns("projects").should == projects
  end

end

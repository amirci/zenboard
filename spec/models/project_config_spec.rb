require 'spec_helper'

describe ProjectConfig do

  it "Should have a user as onwer" do
    user = User.create()
    config = ProjectConfig.create(:user => user)
    config.user.should == user
  end
  
end
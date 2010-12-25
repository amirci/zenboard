require 'spec_helper'

describe User do

  it "Should have associated config" do
    user = User.create()

    10.times { user.configurations << ProjectConfig.create() }
    
    user.should have(10).configurations
  end
  
end
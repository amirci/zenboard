Given /^I have no configured projects$/ do
  # nothing to do, no configured projects exist
end

Given /^I have configured projects:$/ do |table|
  table.raw.collect do |name|
    project_config = ProjectConfig.make(:user => @user, :name => name)
    project_config.save!
  end
end


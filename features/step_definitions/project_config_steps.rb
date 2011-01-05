Given /^I have no project configurations$/ do
  ProjectConfig.destroy_all
end

Given /^I have the project configuration "([^"]*)" with id "([^"]*)"$/ do |name, project_id|
  project_config = ProjectConfig.make(:user => @user, :name => name, :project_id => project_id)
  project_config.save!
end

Given /^(?:I have )the following project configurations:$/ do |table|
  table.hashes.each do |hash|
    project_config = ProjectConfig.make(hash.merge(:user => @user))
    project_config.save!
  end
end

When /^I delete the (\d+)(?:st|nd|rd|th) project configuration$/ do |pos|
  within(".config_key :nth-child(#{pos.to_i + 1})") do
    click_link "Remove"
  end
end

Then /^I should see the following project_configs:$/ do |expected_project_configs_table|
  expected_project_configs_table.diff!(tableish('table tr', 'td,th'))
end

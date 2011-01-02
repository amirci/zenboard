Given /^I have no project configurations$/ do
  # nothing to do, no configured projects exist
end

Given /^I have the project configuration "([^"]*)" with id "([^"]*)"$/ do |name, project_id|
  project_config = ProjectConfig.make(:user => @user, :name => name, :project_id => project_id)
  project_config.save!
end

Given /^(?:I have )the following project configurations:$/ do |table|
  table.raw.collect do |name|
    project_config = ProjectConfig.make(:user => @user, :name => name)
    project_config.save!
  end
end

When /^I delete the (\d+)(?:st|nd|rd|th) project_config$/ do |pos|
  visit project_configs_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following project_configs:$/ do |expected_project_configs_table|
  expected_project_configs_table.diff!(tableish('table tr', 'td,th'))
end

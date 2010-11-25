require 'fakeweb'

Given /^I have the project "([^"]*)"$/ do |project|
  project = {"id" => 4444,
      "name" => "#{project}",
      "description" => "Project developed in rails",
      "createTime" => "\/Date(1256774726000-0500)\/",
      "owner" => {"id" => 2222,"name" => "Some user"}}
    
  fake_response = JSON.generate(project)

  FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/project/4444", :body => fake_response)
end

Given /^I have the projects:$/ do |table|
  
  projects = table.raw.collect do |project| 
    {"id" => 4444,
        "name" => "#{project}",
        "description" => "Project developed in rails",
        "createTime" => "\/Date(1256774726000-0500)\/",
        "owner" => {"id" => 2222,"name" => "Some user"}}  
  end

  fake_response = JSON.generate({"page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 1, "items" => projects})

  FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/projects", :body => fake_response)
  FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/project/4444", :body => JSON.generate(projects[0]))
end

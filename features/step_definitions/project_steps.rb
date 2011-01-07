require 'fakeweb'

Given /^I have no access to search for projects$/ do
  FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/projects", :exception => ActiveResource::ForbiddenAccess)
end

Given /^I have the project "([^"]*)"(?: with:)$/ do |project, table|

  date = table.rows_hash[:created] || "Mar 1"
  created = Chronic.parse(date, :context => :past)

  id = table.rows_hash[:id] || 4444
    
  project = { "id" => id,
      "name" => "#{project}",
      "description" => table.rows_hash[:description] || "Project developed in rails",
      "createTime" => "\/Date(#{created.to_i}000-0500)\/",
      "owner" => {"id" => 2222,"name" => "Some user"}}
    
  projects = JSON.generate( { "page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 6, "items" => [project]})

  story = { "id" => 1, 
    "text" => "End world hunger", "size" => 3, "color" => "gray", "ready" => true, "blocked" => false,
    "reasonBlocked" => "new ideas", "phase" => { "id" => 1, "name" => "Archive"}, "phaseIndex" => 0,
    "creator" => { "id" => 1, "name" => "John Doe"}, "owner" => {"id" => 2222,"name" => "John Spec"},
    "metrics" => { "createdTime" => "\/Date(1256774726000-0500)\/", "startTime" => "\/Date(1256774726000-0500)\/" }
  }

  fake_stories = JSON.generate( { "page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 6, "items" => [story]})

  FakeWeb.register_uri(:get, "https://agilezen.com/api/v1/projects", :body => projects)
  FakeWeb.register_uri(:get, "https://agilezen.com/api/v1/project/#{id}", :body => JSON.generate(project))
  FakeWeb.register_uri(:get, "https://agilezen.com/api/v1/project/#{id}/stories?with=metrics&pageSize=1000", :body => fake_stories)
end

Given /^I have the stories for project "([^"]*)":$/ do |id, table|

  stories = table.hashes.collect do |story|
    started = Chronic.parse(story[:started], :context => :past)
    finished = Chronic.parse(story[:finished], :context => :past)
    story = { "id" => 1, 
      "text" => "End world hunger", "size" => story[:size], "color" => "gray", "ready" => true, "blocked" => false,
      "reasonBlocked" => "new ideas", "phase" => { "id" => 1, "name" => story[:phase]}, "phaseIndex" => 0,
      "creator" => { "id" => 1, "name" => "John Doe"}, "owner" => {"id" => 2222,"name" => "John Spec"},
      "metrics" => { "createdTime" => "\/Date(1256774726000-0500)\/", "startTime" => "\/Date(#{started.to_i}000-0500)\/", "finishTime" => "\/Date(#{finished.to_i}000-0500)\/" }
       }
  end
  
  fake_stories = JSON.generate( { "page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 6, "items" => stories})

  FakeWeb.register_uri(:get, "https://agilezen.com/api/v1/project/#{id}/stories?with=metrics&pageSize=1000", :body => fake_stories)
end

Given /^I have the projects:$/ do |table|
  
  projects = table.raw.collect do |project| 
    {"id" => 4444,
        "name" => "#{project}",
        "description" => "Project developed in rails",
        "createTime" => "\/Date(1256774726000-0500)\/",
        "owner" => {"id" => 2222,"name" => "Some user"}
      }  
  end

  fake_response = JSON.generate({"page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 1, "items" => projects})

  story = {"id" => 1, 
    "text" => "End world hunger", "size" => 3, "color" => "gray", "ready" => true, "blocked" => false,
    "reasonBlocked" => "new ideas", "phase" => { "id" => 1, "name" => "Archive"}, "phaseIndex" => 0,
    "creator" => { "id" => 1, "name" => "John Doe"}, "owner" => {"id" => 2222,"name" => "John Spec"},
    "metrics" => { "createdTime" => "\/Date(1256774726000-0500)\/", "startTime" => "\/Date(1256774726000-0500)\/" }
     }

  fake_stories = JSON.generate( { "page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 6, "items" => [story]})
     
  FakeWeb.register_uri(:get, "https://agilezen.com/api/v1/projects", :body => fake_response)
  FakeWeb.register_uri(:get, "https://agilezen.com/api/v1/project/4444", :body => JSON.generate(projects[0]))
  FakeWeb.register_uri(:get, "https://agilezen.com/api/v1/project/4444/stories?with=metrics&pageSize=1000", :body => fake_stories)

end

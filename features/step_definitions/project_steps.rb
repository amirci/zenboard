require 'fakeweb'

Given /^I have no access to search for projects$/ do
  FakeWeb.register_uri(:get, az_projects, :exception => ActiveResource::ForbiddenAccess)
end

Given /^I have the project "([^"]*)"(?: with:)$/ do |name, table|

  date = table.rows_hash[:created] || "Mar 1"

  created = Chronic.parse(date, :context => :past)
  story_created = Chronic.parse("10 days ago")
  story_started = Chronic.parse("1 day ago")


  id = table.rows_hash[:id] || 4444
  
  description = table.rows_hash[:description] || "Project developed in rails"
  
  owner = Owner.make(:name => "Lorenzo Valdez")
  
  project = Project.make(:owner => owner, :id => id, :name => name, :description => description, :createTime => "#{created.strftime('%FT%T%z')}")
  
  projects = JSON.generate( { "page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 6, "items" => [project.to_hash]})

  story = { "id" => 1, 
    "text" => "End world hunger", "size" => 3, "color" => "gray", "ready" => true, "blocked" => false,
    "reasonBlocked" => "new ideas", "phase" => { "id" => 1, "name" => "Archive"}, "phaseIndex" => 0,
    "creator" => { "id" => 1, "name" => "John Doe"}, "owner" => {"id" => 2222,"name" => "John Spec"},
    "metrics" => { "createdTime" => story_created.strftime('%FT%T%z'), 
                   "startTime" => story_started.strftime('%FT%T%z') }
  }

  fake_stories = JSON.generate( { "page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 6, "items" => [story]})

  FakeWeb.register_uri(:get, az_projects, :body => projects)
  FakeWeb.register_uri(:get, az_project(id), :body => JSON.generate(project.to_hash))
  FakeWeb.register_uri(:get, az_stories_with_metrics(id), :body => fake_stories)
end

Given /^I have the stories for project "([^"]*)":$/ do |id, table|

  stories = table.hashes.collect do |story|
    started = Chronic.parse(story[:started], :context => :past)
    finished = Chronic.parse(story[:finished], :context => :past)
    story = { "id" => 1, 
      "text" => "End world hunger", "size" => story[:size], "color" => "gray", "ready" => true, "blocked" => false,
      "reasonBlocked" => "new ideas", "phase" => { "id" => 1, "name" => story[:phase]}, "phaseIndex" => 0,
      "creator" => { "id" => 1, "name" => "John Doe"}, "owner" => {"id" => 2222,"name" => "John Spec"},
      "metrics" => { "createdTime" => Chronic.parse("10 days ago").strftime('%FT%T%z'), 
                     "startTime" => started.strftime('%FT%T%z'), "finishTime" => finished.strftime('%FT%T%z') }
       }
  end
  
  fake_stories = JSON.generate( { "page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 6, "items" => stories})

  FakeWeb.register_uri(:get, az_stories_with_metrics(id), :body => fake_stories)
end

Given /^I have the projects:$/ do |table|
  
  projects = table.raw.collect do |project| 
    {"id" => 4444,
        "name" => "#{project}",
        "description" => "Project developed in rails",
        "createTime" => Chronic.parse("30 days ago").strftime('%FT%T%z'),
        "owner" => {"id" => 2222,"name" => "Some user"}
      }  
  end

  fake_response = JSON.generate({"page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 1, "items" => projects})

  story = {"id" => 1, 
    "text" => "End world hunger", "size" => 3, "color" => "gray", "ready" => true, "blocked" => false,
    "reasonBlocked" => "new ideas", "phase" => { "id" => 1, "name" => "Archive"}, "phaseIndex" => 0,
    "creator" => { "id" => 1, "name" => "John Doe"}, "owner" => {"id" => 2222,"name" => "John Spec"},
    "metrics" => { "createdTime" => Chronic.parse("10 days ago").strftime('%FT%T%z'), "startTime" => Chronic.Parse("1 day ago").strftime('%FT%T%z') }
     }

  fake_stories = JSON.generate( { "page" => 1,"pageSize" => 10,"totalPages" => 1,"totalItems" => 6, "items" => [story]})
     
  FakeWeb.register_uri(:get, az_projects, :body => fake_response)
  FakeWeb.register_uri(:get, az_project(4444), :body => JSON.generate(projects[0]))
  FakeWeb.register_uri(:get, az_stories_with_metrics(444), :body => fake_stories)
end

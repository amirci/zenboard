module AgileZenPaths

  URL = "http://agilezen.com/api/v1"

  def az_projects
    "#{URL}/projects"
  end
  
  def az_project(id)
    "#{URL}/project/#{id}"
  end

  def az_stories_with_metrics(id)
    "#{URL}/project/#{id}/stories?with=metrics&pageSize=1000"
  end
  
end

World(AgileZenPaths)


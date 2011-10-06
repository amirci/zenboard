class KfuStory < KanbanFuResource
  self.site = "http://localhost:3010/projects/:project_id/"
  self.element_name = "card"
  
end
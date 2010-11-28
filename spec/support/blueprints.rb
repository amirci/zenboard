require 'machinist/object'
require 'sham'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

Project.blueprint do
  id          { "Project 1" }
  name        { "Beautiful Project" }
  description { "Project description" }
  createTime  { "\/Date(1256774726000-0500)\/" }
end

Story.blueprint do
  id      { "Story 1" } 
  text    { "Lorem ipsum...." }
  size    { 2 }
  color   { "gray" }
  ready   { false }
  blocked { false }
  phase   { new Object { |o| o.id, o.name = 1, "Archive" } }
  phaseIndex    { 0 }
  reasonBlocked { "new ideas" } 
  metrics       { new Object { |o| o.createdTime, o.startTime = "\/Date(1256774726000-0500)\/", "\/Date(1256774726000-0500)\/" } }
end
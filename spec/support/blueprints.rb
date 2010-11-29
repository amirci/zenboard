require 'machinist/object'
require 'sham'
require 'faker'

Sham.unique_id   { |i| i }
Sham.name        { Faker::Lorem.sentence }
Sham.text        { Faker::Lorem.sentence }
Sham.date        { "\/Date(#{Time.now.to_i}000-0500)\/" }
Sham.owner       { Owner.new(1, 'Juan Rodrigo')  }
Sham.phase       { Phase.new(1, "Archive") }

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

Project.blueprint do
  id          { Sham.unique_id }
  name        { Sham.name  }
  description { Sham.text  }
  createTime  { Sham.date  }
  owner       { Sham.owner }
end

Story.blueprint do
  id      { Sham.unique_id   } 
  text    { Sham.name }
  size    { 2 }
  color   { "gray" }
  ready   { false }
  blocked       { false }
  phase         { Sham.phase }
  phaseIndex    { 0 }
  reasonBlocked { Sham.text } 
  metrics       { Object.new { |o| o.createdTime, o.startTime = Sham.date, Sham.date } }
end
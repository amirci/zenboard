require 'machinist/object'
require 'sham'
require 'faker'

Sham.unique_id   { |i| i }
Sham.name        { Faker::Lorem.sentence }
Sham.text        { Faker::Lorem.sentence }
Sham.date        { "\/Date(#{Time.now.to_i}000-0500)\/" }
Sham.owner       { Owner.new(1, 'Juan Rodrigo')  }
Sham.size        { rand(13) }

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

Phase.blueprint(:archive) do
  id   { Sham.unique_id }
  name { 'Archive'      }
end

Phase.blueprint do
  id   { Sham.unique_id }
  name 
end

Project.blueprint do
  id          { Sham.unique_id }
  name        
  description { Sham.text  }
  createTime  { Sham.date  }
  owner       
end

Story.blueprint do
  id      { Sham.unique_id   } 
  text    
  size    
  color   { "gray" }
  ready   { false }
  blocked       { false }
  phase         { Phase.make }
  phaseIndex    { 0 }
  reasonBlocked { Sham.text } 
  metrics       { Object.new { |o| o.createdTime, o.startTime = Sham.date, Sham.date } }
end
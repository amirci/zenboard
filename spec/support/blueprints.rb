require 'machinist/object'
require 'sham'
require 'faker'

Sham.unique_id   { |i| i }
Sham.name        { Faker::Lorem.sentence }
Sham.text        { Faker::Lorem.sentence }
Sham.date        { JSONHelper::Date.to_json(Time.now + rand(10)) }
Sham.late_date   { JSONHelper::Date.to_json(Time.now + 10 + rand(20)) }
Sham.owner       { Owner.new(1, 'Juan Rodrigo')  }
Sham.size        { rand(13) }
Sham.createTime  { JSONHelper::Date.to_json(Time.now + rand(10)) }

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

Sham.phase       { Phase.make }

Project.blueprint do
  id          { Sham.unique_id }
  name        
  description { Sham.text  }
  createTime  
  owner       
end

Metrics.blueprint do
  createTime 
  startTime  { Sham.date }
  finishTime { Sham.late_date }
end

Story.blueprint do
  id            { Sham.unique_id   } 
  text    
  size    
  color         { "gray" }
  ready         { false }
  blocked       { false }
  phase         
  phaseIndex    { 0 }
  reasonBlocked { Sham.text } 
  metrics       { Metrics.make }
end
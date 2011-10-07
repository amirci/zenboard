require 'spec_helper'

describe KfuStory do
  
  let(:project) { double(KfuProject, id: 8, name: 'Super Project', description: 'The best project') }

  let(:finished_on) { DateTime.parse('Nov 3, 2011') }
  let(:started_on)  { DateTime.parse('Nov 1, 2011') }
  
  let(:story)  { { 'id' => 267,
                   'title' => 'User login', 
                   'finished_on'  => finished_on.to_s,
                   'started_on'   => started_on.to_s,
                   'blocked_time' => 20,
                   'waiting_time' => 10,
                   'phase' => 'working',
                   'size'  => 3,
                   'description'  => 'As a user I want to login'} }
  
  let(:cards_url) { "http://localhost:3010/projects/#{project.id}/cards" }
  
  before(:each) do
    FakeWeb.allow_net_connect = false
  end

  describe "#all" do
    let(:phase) { Phase.new('working') }
    
    before do 
      FakeWeb.register_uri(:get, "#{cards_url}.json", :body => { "cards" => [story] }.to_json) 
    end
    
    subject { KfuStory.find(:all, params: { project_id: project.id }).first }
    
    its(:started_on)   { should == story['started_on']   }
    its(:finished_on)  { should == story['finished_on']  }
    its(:blocked_time) { should == story['blocked_time'] }
    its(:waiting_time) { should == story['waiting_time'] }
    its(:title)        { should == story['title']        }
    its(:description)  { should == story['description']  }
    its(:size)         { should == story['size'] }
    it { subject.phase.name.should == phase.name }
  end

  context 'when the story has not been completed' do
    subject { KfuStory.new(story.merge('finished_on' => nil)) }
    its(:finished_on) { should == nil }
    its(:duration)    { should == nil }
    its(:work_time)   { should == nil }
    its(:efficiency)  { should == nil }
    its(:point_duration) { should == nil }
  end

  context 'when the story has been completed' do
    let(:duration) { finished_on - started_on }
    let(:work_time) { duration - story['blocked_time'] - story['waiting_time'] }
    
    subject { KfuStory.new(story) }
    
    its(:started_on)  { should == started_on }
    its(:finished_on) { should == finished_on }
    its(:duration)    { should == duration }
    its(:work_time)   { should == work_time }
    its(:efficiency)  { should == work_time / duration * 100 }
    its(:point_duration) { should == story['size'] / (finished_on - started_on) }
  end  

end

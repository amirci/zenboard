require 'spec_helper'

describe KfuStory do
  
  let(:project) { double(KfuProject, id: 8, name: 'Super Project', description: 'The best project') }

  let(:story)  { { 'id' => 267,
                   'title' => 'User login', 
                   'finished_on'  => DateTime.parse('Nov 3, 2011'),
                   'started_on'   => DateTime.parse('Nov 1, 2011'),
                   'blocked_time' => 20,
                   'waiting_time' => 10,
                   'phase' => 'working',
                   'size'  => 3,
                   'description'  => 'As a user I want to login'} }
  
  let(:cards_url) { "http://localhost:3010/projects/#{project.id}/cards" }
  
  before(:each) do
    FakeWeb.allow_net_connect = false
  end

  context "#all" do
    let(:phase) { double(Phase, name: 'working') }
    
    before do 
      FakeWeb.register_uri(:get, "#{cards_url}.json", :body => { "cards" => [story] }.to_json) 
      
      Phase.stub(:find_by_name).with(phase.name).and_return(phase)
    end
    
    subject { KfuStory.find(:all, params: { project_id: project.id }).first }
    
    its(:started_on)   { should == story['started_on']   }
    its(:finished_on)  { should == story['finished_on']  }
    its(:blocked_time) { should == story['blocked_time'] }
    its(:waiting_time) { should == story['waiting_time'] }
    its(:title)        { should == story['title']        }
    its(:description)  { should == story['description']  }
    its(:phase)        { should == phase }
    its(:size)         { should == story['size'] }
  end

  context '.duration' do
  end
  
end

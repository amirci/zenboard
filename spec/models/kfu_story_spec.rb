require 'spec_helper'

describe KfuStory do
  
  let(:project) { double(KfuProject, id:8, name: 'Super Project', description: 'The best project') }

  let(:story)  { KfuStory.new(title: 'User login', 
                              description: 'As a user I want to login') }
  
  before(:each) do
    FakeWeb.allow_net_connect = false

    FakeWeb.register_uri(:get, 
                         "http://localhost:3010/projects/#{project.id}/cards.json", 
                         :body => { "cards" => [story.attributes] }.to_json)
  end

  context "#all" do
    subject { KfuStory.find(:all, params: { project_id: project.id }).map { |s| s.attributes } }
    
    it { should == [story.attributes] }
  end

end

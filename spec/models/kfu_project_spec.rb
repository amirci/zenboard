require 'spec_helper'
require 'fakeweb'
require 'json'

describe KfuProject do

  let(:owner)   { double(Owner, :name => "Lorenzo Valdez") }
  let(:archite) { Phase.make(:archive) }
  let(:working) { Phase.make(:working) }
  
  let(:project) { KfuProject.new(id:8, name: 'Super Project', description: 'The best project') }
  
  before(:each) do
    FakeWeb.allow_net_connect = false
    
    FakeWeb.register_uri(:get, 
                         "http://localhost:3010/projects.json", 
                         :body => { "projects" => [project.attributes] }.to_json)

    FakeWeb.register_uri(:get, 
                         "http://localhost:3010/projects/#{project.id}.json", 
                         :body => {'project' => project.attributes.to_json})
  end

  context "#all" do
    subject { KfuProject.all }
    it { should == [project] }
  end

  context "#find" do
    subject { KfuProject.find(project.id) }    
    it { should == project }
  end
  
  context ".stories" do
    let(:stories) { (1..10).collect { double(Story) } }
    before { KfuStory.stub(:find).with(:all, params: { project_id: project.id }).and_return(stories) }
    subject { project }
    its(:stories) { should == stories }
  end
end

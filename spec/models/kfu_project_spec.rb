require 'spec_helper'
require 'fakeweb'
require 'json'

describe KFuProject do

  let(:owner)   { double(Owner, :name => "Lorenzo Valdez") }
  let(:archite) { Phase.make(:archive) }
  let(:working) { Phase.make(:working) }
  
  let(:project) { KFuProject.new(id:8, name: 'Super Project', description: 'The best project') }
  
  before(:each) do
    FakeWeb.register_uri(:get, 
                         "http://localhost:3010/projects.json", 
                         :body => { "projects" => [project.attributes] }.to_json)

    FakeWeb.register_uri(:get, 
                         "http://localhost:3010/projects/#{project.id}.json", 
                         :body => project.attributes.to_json)
  end

  context "#all" do
    subject { KFuProject.all }
    it { should == [project] }
  end

  context "#find" do
    subject { KFuProject.find(project.id) }    
    it {should == project}
  end
  
  context ".stories" do
    before { KFuStory.stub(:all_for_project).with(project.id).and_return([]) }
    
    subject { project }

    its(:stories) { should == [KFuStory.new] }
  end
end

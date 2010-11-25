require 'spec_helper'

describe ItemsController do

  it "Should obtain all projects" do
    fake_response = "<?xml version=\"1.0\" encoding=\"utf-8\"?>
    <projects>
      <items>
        <project>
          <createTime>2009-10-28T19:05:26</createTime>
          <description>Media  Library developed in rails</description>
          <id>2146</id>
          <name>Rails Media Library</name>
          <owner>
            <id>4567</id>
            <name>Amir Barylko</name>
          </owner>
        </project>
      </items>
      <page>1</page>
      <pageSize>10</pageSize>
      <totalItems>1</totalItems>
      <totalPages>1</totalPages>
    </projects>"

    #FakeWeb.register_uri(:get, "http://agilezen.com:80/api/v1/projects.json", :body => fake_response)

    #result = Net::HTTP.get(URI.parse("http://agilezen.com:80/api/v1/projects?apikey=f7ba5d7ea3254f31aa15d17e3d4e8ee1"))
    #result = Net::HTTP.get(URI.parse("http://agilezen.com/api/v1/projects"))

    #puts "****** #{result} ********"
    
    get :index
    
    response.should be_success
    assigns("items").should_not be_empty
    assigns("items").first.name.should be "Rails Media Library"
  end
  
end

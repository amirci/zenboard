require 'fakeweb'

Given /^I have the project "([^"]*)"$/ do |arg1|
  response = "
  <?xml version=\"1.0\" encoding=\"utf-8\"?>
  <projects>
    <page>1</page>
    <pageSize>10</pageSize>
    <totalPages>1</totalPages>
    <totalItems>2</totalItems>
    <items>
      <project>
        <id>123</id>
        <name>World Peace</name>
        <description>Working towards world peace</description>
        <owner>
          <id>1</id>
          <name>John Doe</name>
        </owner>
      </project>
      <project>
        <id>124</id>
        <name>#{arg1}</name>
        <description>Secret plan to conquer the world</description>
        <owner>
          <id>1</id>
          <name>John Doe</name>
        </owner>
      </project>
    </items>
  </projects>"
  FakeWeb.register_uri(:get, "http://agilezen.com/api/v1/projects", :body => response)
end
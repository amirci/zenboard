@wip
Feature: Manage project configurations
  As a registered user
  I want to add a new project configuration
  So I can get project details
  
  Scenario: Add new project configuration
	Given I'm logged in
	And   I have no project configurations
	When  I go to the user projects configuration page
	And   I follow "Configure"
	Then  I should see "Add API Key"

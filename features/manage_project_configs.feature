@f1
Feature: Manage project configurations
  As a registered user
  I want to add a new project configuration
  So I can get project details
  
  Scenario: Search for new projects
	Given I'm logged in
    And   I have the project "Caruso" with:
		  | description | Very nice project |
	When  I go to the user projects configuration page
	And   I fill in "project_config_api_key" with "aaa"
	And   I press "Search"
 	Then  I should see "Caruso" within "#projects"

  Scenario: Search for new projects needs an api-key
	Given I'm logged in
    And   I have the project "Caruso" with:
		  | description | Very nice project |
	When  I go to the user projects configuration page
	And   I press "Search"
 	Then  I should see "Sorry, you need an api-key in order to search for projects"

  Scenario: Search for new projects with the wrong key
	Given I'm logged in
	And   I have no access to search for projects
	When  I go to the user projects configuration page
	And   I fill in "project_config_api_key" with "fca5c1c8b746160460a9"
	And   I press "Search"
 	Then  I should see "Can't retrieve project information, make sure the key is valid"

  @javascript
  Scenario: Add new configuration
	Given I'm logged in
    And   I have the project "Caruso" with:
		  | description | Very nice project |
	And   I go to the user projects configuration page
	And   I fill in "project_config_api_key" with "aaa"
	And   I press "Search"
	When  I follow "Add"
	Then  I should see "Caruso" within "div#configurations"
	And   I should see "(Added)" within "#projects"
	And   I should see "The new project configuration has been added"

  Scenario: Listing exisiting configuration should appear as added
	Given I'm logged in
    And   I have the project "Moroco" with:
		  | description | Project |
		  | id          | 1       |
    And   I have the project configuration "Moroco" with id "1"
	And   I go to the user projects configuration page
	And   I fill in "project_config_api_key" with "aaa"
	When  I press "Search"
	Then  I should see "(Added)" within "#projects"

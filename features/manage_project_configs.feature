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

	@wip
  Scenario: Search for new projects needs an api-key
	Given I'm logged in
    And   I have the project "Caruso" with:
		  | description | Very nice project |
	When  I go to the user projects configuration page
	And   I press "Search"
 	Then  I should see "Sorry, you need an api-key in order to search for projects"

  Scenario: Add new configuration
	Given I'm logged in
    And   I have the project "Caruso" with:
		  | description | Very nice project |
	And   I go to the user projects configuration page
	And   I fill in "project_config_api_key" with "aaa"
	And   I press "Search"
	When  I follow "Add"
	Then  I should see "Caruso" within "#configurations"

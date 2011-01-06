@f1
Feature: Manage project configurations
  As a registered user
  I want to manage new project configuration
  So I can add and remove configurations

  Scenario: No projects are configured
    Given I'm logged in
    And   I have no project configurations
	When  I go to the user projects configuration page
	Then  I should see "You have no configured projects"
	 
  Scenario: The user has configured projects
    Given I'm logged in
    And   I have the following project configurations:
	        | name     |
			| Caruso   |
			| Pucini   | 
			| Mariachi |
	When  I go to the user projects configuration page
	Then  I should see "Caruso"
    And   I should see "Pucini"
    And   I should see "Mariachi"
  
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
	And   I fill in "api_key" with "fca5c1c8b746160460a9"
	And   I press "Search"
 	Then  I should see "Can't retrieve project information, make sure the key is valid"

  @javascript
  Scenario: Add new configuration
	Given I'm logged in
    And   I have no project configurations
    And   I have the project "Caruso" with:
		  | description | Very nice project |
	And   I go to the user projects configuration page
	And   I fill in "api_key" with "aaa"
	And   I press "Search"
	When  I follow "Add"
	Then  I should see "Caruso" within "div#configurations"
	And   I should see "(Added)" within "#projects"
	And   I should see "The new project configuration has been added"

  Scenario: Delete project configuration
    Given I'm logged in
    And   I have the following project configurations:
	        | name     | api_key |
			| Caruso   | aaa     |
			| Pucini   | aaa     | 
			| Mariachi | aaa     |
	When  I go to the user projects configuration page
    And   I delete the 1st project configuration
	Then  I should not see "Caruso"
    And   I should see "Pucini"
    And   I should see "Mariachi"

  Scenario: See project configuration detail
    Given I'm logged in
    And   I have the following project configurations:
	        | name     | api_key | project_id |
			| Caruso   | aaa     | 44         |
    And   I have the project "Caruso" with:
		    | description | Very nice project |
		    | id          | 44                |
	When  I go to the user projects configuration page
    And   I follow detail of 1st project configuration
	Then  I should see "Caruso"
	And   I should see "Very nice project"

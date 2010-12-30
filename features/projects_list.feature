Feature: Listing projects for current user
  As a user
  I Want to see the list of configured projects
  So I can choose one to see the details

  Scenario: No projects are configured
    Given I'm logged in
    And   I have no project configurations
	When  I go to the user projects configuration page
	Then  I should see "You have no configured projects"
	 
  Scenario: The user has configured projects
    Given I'm logged in
    And   I have the following project configuration:
			| Caruso   |
			| Pucini   | 
			| Mariachi |
	When  I go to the user projects configuration page
	Then  I should see "Caruso"
    And   I should see "Pucini"
    And   I should see "Mariachi"


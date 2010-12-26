Feature: Listing projects for current user
  As a user
  I Want to see the list of configured projects
  So I can choose one to see the details

  Scenario: No projects are configured
    Given I'm logged in
    And   I have no configured projects
	When  I go to the user projects config page
	Then  I should see "You have no configured projects"
	 
  @wip
  Scenario: The user has configured projects
    Given I'm logged in
    And   I have configured projects:
			| Caruso   |
			| Pucini   | 
			| Mariachi |
	When  I go to the user projects config page
	Then  I should see "Caruso"
    And   I should see "Pucini"
    And   I should see "Mariachi"
@f2
Feature: Get the details of a project
  As a user
  I Want to see the details of a project
  So I can see the info like days per user point

  Scenario: The project details requires to be logged in
    Given I'm not logged in
	When  I go to the project "4444" detail page
	Then  I should see "You need to sign in"

  Scenario: Follow the project configuration to obtain the details
    Given I'm logged in
    And   I have the following project configurations:
	        | name     | api_key | project_id |
			| Caruso   | aaa     | 4444       |
    And   I have the project "Caruso" with:
		    | description | Super Project |
		    | id          | 4444          |
	When  I go to the project "4444" detail page
	Then  I should see "Description: Super Project"

  Scenario: Get the average velocity of a project
    Given I'm logged in
    And   I have the following project configurations:
	        | name     | api_key | project_id |
			| Caruso   | aaa     | 44       |
    And   I have the project "Caruso" with:
		    | description | Super Project |
		    | id          | 44            |
		    | created     | Mar 1         |
	And   I have the stories for project "44":
	        | size | started | finished | phase   |
	        |  3   | Mar 1   | Mar 3    | Archive |
	        |  5   | Mar 1   | Mar 5    | Archive |
	        |  8   | Mar 1   | Mar 8    | Archive |
	When  I go to the project "44" detail page
	Then  I should see "Velocity: 16 point(s)"
	And   I should see "1 point: 0.08 day(s)"

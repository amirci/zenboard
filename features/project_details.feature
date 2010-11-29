Feature: Get the details of a project
  As a user
  I Want to see the details of a project
  So I can see the info like days per user point

  Scenario: Follow the project to obtain the details
    Given I'm logged in
    And   I have the project "Caruso" with:
		  | description | Very nice project |
	And   I go to the projects page
	When  I follow "Caruso"
	Then  I should see "Description: Very nice project"

@wip
  Scenario: Get the average velocity of a project
    Given I'm logged in
    And   I have the project "Caruso" with:
 		  | id      | 44         |
		  | created | 8 days ago |
	And   I have the stories for project "44":
	      | size | started | finished | phase   |
	      |  3   | Jan 1   | Jan 3    | Archive |
	      |  5   | Jan 1   | Jan 5    | Archive |
	      |  8   | Jan 1   | Jan 8    | Archive |
	When  I go to the project "44" detail page
	Then  I should see "Velocity: 16 point(s)"
	And   I should see "1 point: 0.78 day(s)"

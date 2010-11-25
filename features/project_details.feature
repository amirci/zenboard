@wip
Feature: Get the details of a project
  As a user
  I Want to see the details of a project
  So I can see the info like days per user point

  Scenario: Get the details of one project
    Given I'm logged in
    And   I have the project "Caruso"
	And   I go to the projects page
	And   show me the page
	And   I follow "Go"
	When  I follow "Caruso"
	Then  I should see "Average point duration: 1.2"

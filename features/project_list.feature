@wip
Feature: Listing projects
  As a user
  I Want to see the list of projects
  So I can choose one to see the details


  Scenario: List all projects
    Given I'm logged in
    And   I have the project "Caruso"
    When  I go to the home page
    Then  I should see "Caruso"
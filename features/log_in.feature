Feature: Log in to the dashboard
  As a user
  I want to login to the dashboard
  So I can see all my AgileZen projects


  Scenario: Successfull login
     Given I go to the home page
     When  I fill in "username" with "displacement_dev"
     And   I fill in "password" with "dev123"
     Then  I should see "Welcome displacement_dev"
     And   I should see "Project Displacement"
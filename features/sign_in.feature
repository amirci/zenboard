Feature: Signing in 
	In order to use the site 
	As a user 
	I want to be able to sign in
	
  Scenario: Signing in via confirmation 
	  	Given there are the following users:
				| email	            | password | unconfirmed | 
				| user@zenboard.com | password | true	     |
		And "user@zenboard.com" opens the email with subject "Confirmation instructions" 
		And  they click the first link in the email 
		Then I should see "Your account was successfully confirmed" 
		And  I should see "Signed in as user@zenboard.com"
		And  I should see "Sign out"

  Scenario: Signing in via form 
		Given there are the following users:
				| email	            | password | unconfirmed | 
				| user@zenboard.com | password | false	     |
	    And  I am on the homepage 
	    When I follow "Sign in" 
	    And  I fill in "Email" with "user@zenboard.com" 
	    And  I fill in "Password" with "password"
		And  I press "Sign in" 
		Then I should see "Signed in successfully."
		And  I should see "Signed in as user@zenboard.com"
		And  I should see "Sign out"
		
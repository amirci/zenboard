Given /^I am not authenticated$/ do
  visit destroy_user_session_path
end

Given /^I'm not logged in$/ do
  Given %Q{I am not authenticated}
end

Given /^I'm logged in$/ do
  email    = 'testing@man.net'
  login    = 'Testing man'
  password = 'secretpass'

  Given %{I have the user "#{email}" with password "#{password}" and login "#{login}"}
  And %{I go to sign in page}
  And %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  And %{Wait for 20 secs}
  And %{I press "Sign in"}
end
Given /^there are the following users:$/ do |table|
  table.hashes.each do |attributes|
    unconfirmed = attributes.delete("unconfirmed") == "true"
    @user = User.create!(attributes.merge!(:password_confirmation => attributes[:password]))
    @user.confirm! unless unconfirmed
  end
end


Given /^I have the user "([^\"]*)" with password "([^\"]*)" and login "([^\"]*)"$/ do |email, password, login|
  @user = User.create!(:email => email,
           :login => login,
           :password => password,
           :password_confirmation => password)
  @user.confirm!
end
source 'http://rubygems.org'

gem 'rails', '3.0.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3-ruby', :require => 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
gem 'haml'

gem 'devise', '1.2.rc'
gem 'omniauth'
gem 'oa-oauth', :require=>"omniauth/oauth"
gem 'oa-openid', :require => 'omniauth/openid'
gem 'simple-navigation'
gem 'bluecloth', ">= 2.0.0"
gem 'json'
gem 'gchartrb'

# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

# Add rspec-rails to the :test and :development groups to the Gemfile.

group :test, :development do
  gem 'rspec-rails', '>= 2.0.0.beta.22'
	gem 'fakeweb'
	gem 'chronic', '< 0.3.0'
	gem 'machinist', '< 2.0.0'
	gem 'faker'
	gem 'heroku'
	gem 'email_spec'
	gem 'nifty-generators'
	gem 'rcov'
	gem 'hpricot'
	gem 'ruby_parser'
end

group :cucumber do
    gem 'capybara', '= 0.4.0'
    gem 'database_cleaner'
    gem 'cucumber-rails'
    gem 'cucumber', '= 0.9.4'
    gem 'spork'
    gem 'launchy'
end

gem "mocha", :group => :test

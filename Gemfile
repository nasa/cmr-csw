source 'https://rubygems.org'

gem 'rails', '4.2.7.1'

gem 'unicorn'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'

  gem 'execjs'

  gem 'therubyracer'

  gem 'uglifier'
end

gem 'jquery-rails'

gem 'nokogiri'

gem 'rest-client', '~> 1.8.0'

gem 'rgeo'

gem 'georuby'

# DSL grammar parsing and interpreting (used for CQL)
gem 'parslet'

group :development do
  gem 'pry-rails'
end

group :profile do
  gem 'ruby-prof'
end

group :test, :development do
  gem 'rspec-rails'
  #gem 'rspec', :require => false
  gem 'rspec_junit_formatter'
end

group :test do
  gem 'vcr'
  gem 'webmock'
  gem 'capybara'
  gem 'rack-test'
end

gem 'bundler-audit'

gem 'responders', '~> 2.0'

group :production, :sit, :uat do
  gem 'rails_12factor'
end
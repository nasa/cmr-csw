source 'https://rubygems.org'

gem 'rails', '>= 4.2.11.1'
gem 'unicorn'
gem 'jquery-rails'
gem 'nokogiri'
gem 'rest-client', '~> 1.8.0'
gem 'rgeo'
gem 'georuby'
# DSL grammar parsing and interpreting (used for CQL)
gem 'parslet'
gem 'bundler-audit'
gem 'responders', '~> 2.0'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'execjs'
  gem 'therubyracer'
  gem 'uglifier'
end

group :development do
  gem 'pry-rails'
end

# memory profiling
group :profile do
  gem 'ruby-prof'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'rspec_junit_formatter'
end

group :test do
  gem 'vcr'
  gem 'webmock'
  gem 'capybara'
  gem 'rack-test'
end

group :production, :sit, :uat do
  gem 'rails_12factor'
end

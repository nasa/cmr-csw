source 'https://rubygems.org'
ruby File.read('.ruby-version').chomp.split('-')[1] { |f| "ruby '#{f}'"}

gem 'rails', '>= 4.2.11.1'
gem 'unicorn'
gem 'jquery-rails', '~> 3.1.3'
gem 'nokogiri', '>= 1.10.4'
gem 'rest-client', '~> 2.0.2'
gem 'rgeo'
gem 'georuby'
# DSL grammar parsing and interpreting (used for CQL)
gem 'parslet'

gem 'responders', '~> 2.0'
gem 'loofah', '>= 2.3.1'
gem 'rack', '~> 1.6.11'
gem 'rake', '12.3.3'
gem 'sprockets', '3.7.2'
gem 'sass', '3.7.4'

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

gem 'bundler-audit'

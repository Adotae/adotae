# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.1.0"

# Use pg as the database for Active Record
gem "pg", "~> 1.1"

# Use Puma as the app server
gem "puma", "~> 5.0"

# Use Active Model has_secure_password
gem "bcrypt", "~> 3.1.7"

# API token authentication (access and refresh tokens)
gem "api_guard", "~> 0.5.2"

# API authorization
gem "pundit"

# API versioning
gem "versionist"

# Serialization
gem "blueprinter"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

# Validates CPF & CNPJ
gem "cpf_cnpj"

# Sentry for unhandled errors and exceptions
gem "sentry-ruby"
gem "sentry-rails"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  # RSpec testing framework for Rails
  gem "rspec-rails", "~> 4.0.1"
  # FactoryBot for testing
  gem "factory_bot_rails"
  # Generates test coverage report
  gem "simplecov"
end

group :development do
  gem "listen", "~> 3.3"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  # Pretty print Ruby objects
  gem "awesome_print"
end

group :test do
  # Cleans test database before every test suite
  gem "database_cleaner-active_record"
  # Generates fake data for testing
  gem "faker"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

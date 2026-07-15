# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.5'

# core
gem 'bootsnap', require: false
gem 'hashids', '~> 1.0.6'
gem 'pg'
gem 'puma', '>= 5.0'
gem 'rails', '~> 8.0.4'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'rspec-rails'
end

group :development do
  gem 'rubocop', '~> 1.67', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

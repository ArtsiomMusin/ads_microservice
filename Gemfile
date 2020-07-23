source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

gem 'sinatra'
gem 'sinatra-contrib'
gem 'sinatra-activerecord'
gem 'pg'

gem 'rake'
gem 'puma'

gem 'i18n'
gem 'fast_jsonapi', '~> 1.5'
gem 'kaminari', '~> 1.2.1'
gem 'emk-sinatra-url-for'
gem 'sinatra-strong-params', require: 'sinatra/strong-params'
gem 'dry-initializer', '~> 3.0.3'

group :development do
  gem 'byebug'
end

group :test do
  gem 'rspec'
  gem 'factory_bot'
  gem 'rack-test'
  gem 'database_cleaner-sequel'
end

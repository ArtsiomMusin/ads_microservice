# Rakefile
require "sinatra/activerecord/rake"

ENV['RACK_ENV'] ||= 'development'

namespace :db do
  task :load_config do
    require "./config/environment"
  end
end

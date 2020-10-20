ENV['RACK_ENV'] ||= 'production'

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

require_relative 'application_loader'
ApplicationLoader.load_app!

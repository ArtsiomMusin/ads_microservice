require 'rubygems'
require 'bundler'

Bundler.require

require './ads'
run Sinatra::Application

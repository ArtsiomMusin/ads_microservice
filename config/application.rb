require 'sinatra/url_for'

class Application < Sinatra::Base
  #helpers Validations
  helpers Sinatra::UrlForHelper

  configure do
    register Sinatra::Namespace
    register ApiErrors

    set :database_file, 'config/database.yml'
    set :app_file, File.expand_path('../config.ru', __dir__)
  end

  configure :development do
    register Sinatra::Reloader

    set :show_exception, false
  end
end

require 'sinatra'
require 'sinatra/extension'

module ApiErrors
  extend Sinatra::Extension

  private

  class NotAuthorized < StandardError; end

  helpers do
    def error_response(error_messages)
      errors = case error_messages
      when ActiveRecord::Base
        ErrorSerializer.from_model(error_messages)
      else
        ErrorSerializer.from_messages(error_messages)
      end
  
      json errors
    end
  end
 
  error ActiveRecord::RecordNotFound do
    status 404
    error_response(I18n.t(:not_found, scope: 'api.errors'))
  end

  error ActiveRecord::RecordNotUnique do
    status 422
    error_response(I18n.t(:not_unique, scope: 'api.errors'))
  end

  error KeyError, ArgumentError do
    status 422
    error_response(I18n.t(:missing_parameters, scope: 'api.errors'))
  end

  error ApiErrors::NotAuthorized do
    status 404
    error_response(I18n.t(:not_authorized, scope: 'api.errors'))
  end
end

require 'sinatra'
require 'sinatra/activerecord'
require 'will_paginate'
require 'will_paginate/active_record'
require_relative 'models/ad'
require_relative 'helpers/pagination_links'
require_relative 'serializers/ad_serializer'
require_relative 'serializers/error_serializer'
require_relative 'services/create_service'
#require 'byebug'

set :database_file, 'config/database.yml'

helpers do
  def error_response(error_messages, status)
    errors = case error_messages
    when ActiveRecord::Base
      ErrorSerializer.from_model(error_messages)
    else
      ErrorSerializer.from_messages(error_messages)
    end
  
    [status, nil, errors.to_json]
  end 
end

get '/' do
  extend PaginationLinks

  ads = Ad.order(updated_at: :desc).page(params[:page])
  serializer = AdSerializer.new(ads, links: pagination_links(ads))

  serializer.serialized_json
end

post '/' do
  body = JSON.parse request.body.read
  result = CreateService.call(
    ad: body,
    user_id: body[:user_id] # TODO: should be taken from Auth service later?
  )

  if result.success?
    serializer = AdSerializer.new(result.ad)
    [201, nil, serializer.serialized_json]
  else
    error_response(result.ad, 422)
  end
end

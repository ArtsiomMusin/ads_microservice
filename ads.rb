require 'sinatra'
require 'sinatra/activerecord'
require 'will_paginate'
require 'will_paginate/active_record'
require_relative 'models/ad'
require_relative 'helpers/pagination_links'
require_relative 'serializers/ad_serializer'
#require 'byebug'

set :database_file, 'config/database.yml'

get '/' do
  extend PaginationLinks
  ads = Ad.order(updated_at: :desc).page(params[:page])
  serializer = AdSerializer.new(ads, links: pagination_links(ads))

  serializer.serialized_json
end

post '/' do
  'Create a new ads here'
end

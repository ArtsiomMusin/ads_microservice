class AdsRoutes < Application
  include PaginationLinks

  get '/ads' do
    ads = Ad.order(updated_at: :desc).page(params[:page])
    serializer = AdSerializer.new(ads, links: pagination_links(ads))
  
    status 200
    json serializer
  end
  
  post '/ads' do
    result = CreateService.call(
      ad: params.dig('ad'),
      user_id: params.dig('ad', 'user_id') # TODO: should be taken from Auth service later?
    )
  
    if result.success?
      serializer = AdSerializer.new(result.ad)
      status 201
      json serializer
    else
      status 422
      error_response(result.ad)
    end
  end

  put '/ads/:id' do
    data = JSON(request.body.read)
    result = UpdateService.call(
      params[:id], 
      lat: data['lat'], 
      lon: data['lon']
    )
    
    if result.success?
      serializer = AdSerializer.new(result.ad)
      status 201
      json serializer
    else
      status 422
      error_response(result.ad)
    end
  end
end

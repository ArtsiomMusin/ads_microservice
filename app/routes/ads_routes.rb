class AdsRoutes < Application
  include PaginationLinks, Auth

  get '/ads' do
    ads = Ad.order(updated_at: :desc).page(params[:page])
    serializer = AdSerializer.new(ads, links: pagination_links(ads))
  
    status 200
    json serializer
  end
  
  post '/ads' do
    result = CreateService.call(
      ad: params.dig('ad'),
      user_id: user_id
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
    Application.logger.info(
      'update body',
      body: data.to_json
    )
    result = UpdateService.call(
      params[:id], 
      lat: data['lat'], 
      lon: data['lon']
    )

    Application.logger.info(
      'update result',
      result: result
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

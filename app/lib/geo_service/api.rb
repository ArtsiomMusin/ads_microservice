module GeoService
  module Api
    def coord(city)
      response = connection.get('/', city: city)
      response.success? && response.body
    end
  end
end

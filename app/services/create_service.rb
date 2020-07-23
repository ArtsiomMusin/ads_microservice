require_relative 'basic_service'

class CreateService
  prepend BasicService

  option :ad do
    option :title
    option :description
    option :city
    option :user_id
  end

  #option :user

  attr_reader :ad

  def call
    @ad = ::Ad.new(@ad.to_h)
    find_city_coord
    return fail!(@ad.errors) unless @ad.save
  end

  private

  def find_city_coord
    geo_client = GeoService::Client.new
    coordinates = geo_client.coord(@ad.city)
    @ad.lat, @ad.lon = coordinates if coordinates
  end
end

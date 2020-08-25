require_relative 'basic_service'

class CreateService
  prepend BasicService

  option :ad do
    option :title
    option :description
    option :city
    option :user_id
  end

  option :geo_client, default: proc { GeoService::Client.new }

  attr_reader :ad

  def call
    @ad = ::Ad.new(@ad.to_h)
    return fail!(@ad.errors) unless @ad.save

    @geo_client.geocode_later(@ad)
  end
end

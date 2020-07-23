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
    return fail!(@ad.errors) unless @ad.save

    #GeocodingJob.perform_later(@ad) - TODO: move to a separate service in future lessons
  end
end

require_relative 'basic_service'

class UpdateService
  prepend BasicService

  param :id
  param :data

  option :ad, default: proc { Ad.find_by(id: @id) }

  def call
    return fail(I18n.t(:not_found, scope: 'api.errors')) if @ad.blank?

    @ad.update(lat: @data[:lat], lon: @data[:lon])
  end
end

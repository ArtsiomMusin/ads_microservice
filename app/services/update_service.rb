require_relative 'basic_service'

class UpdateService
  prepend BasicService

  param :id
  param :data

  option :ad, proc: { Ad.first(id: @id)}

  def call
    return fail(I18n.t(:not_found, scope: 'api.errors')) if @ad.blank?

    @ad.update_fields(data, %i[lat lon])
  end
end

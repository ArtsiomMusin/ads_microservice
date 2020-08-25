module Auth
  def user_id
    client = AuthService::RpcClient.fetch
    data = client.auth(request.env['HTTP_AUTHORIZATION'])
    raise ApiErrors::NotAuthorized if data.result.blank?

    JSON(data.result)['id']
  end
end

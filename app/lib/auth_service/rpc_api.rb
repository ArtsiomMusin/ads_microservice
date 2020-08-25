module AuthService
  module RpcApi
    def auth(token)
      payload = {token: token}.to_json
      publish(payload, type: 'ads')
    end
  end
end

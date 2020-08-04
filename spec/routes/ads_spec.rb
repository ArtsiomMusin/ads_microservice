RSpec.describe AdsRoutes, type: :route do
  describe 'GET /ads' do
    before do
      create_list(:ad, 3)
    end

    it 'returns a collection of ads' do
      get '/ads'

      expect(last_response.status).to eq(200)
      expect(response_body['data'].size).to eq(3)
    end
  end

  describe 'POST /ads (valid auth token)' do
    context 'missing parameters' do
      it 'returns an error' do
        post '/ads'

        expect(last_response.status).to eq(422)
      end
    end

    context 'invalid parameters' do
      let(:ad_params) do
        {
          title: 'Ad title',
          description: 'Ad description',
          city: '',
          user_id: 1
        }
      end

      it 'returns an error' do
        post '/ads', ad: ad_params

        expect(last_response.status).to eq(422)
        expect(response_body['errors']).to include(
          {
            'detail' => 'Укажите город',
            'source' => {
              'pointer' => '/data/attributes/city'
            }
          }
        )
      end
    end

    context 'valid parameters' do
      let(:ad_params) do
        {
          title: 'Ad title',
          description: 'Ad description',
          city: 'City',
          user_id: 1
        }
      end

      let(:last_ad) { Ad.last }

      it 'creates a new ad' do
        expect { post '/ads', ad: ad_params }
          .to change { Ad.count }.from(0).to(1)

        expect(last_response.status).to eq(201)
      end

      it 'returns an ad' do
        post '/ads', ad: ad_params
        expect(response_body['data']).to a_hash_including(
          'id' => last_ad.id.to_s,
          'type' => 'ad'
        )
      end
    end

    # context 'existing city' do
    #   let(:lat) { 45.05 }
    #   let(:lon) { 90.05 }

    #   let(:ad_params) do
    #     {
    #       title: 'Ad title',
    #       description: 'Ad description',
    #       city: 'City 17',
    #       user_id: 1
    #     }
    #   end
  
    #   before do
    #     allow_any_instance_of(GeoService::Api).to receive(:coord)
    #       .with('City 17')
    #       .and_return([lat, lon])
    #   end
  
    #   it 'updates ad coordinates' do
    #     post '/ads', ad: ad_params
  
    #     ad = Ad.last
    #     expect(ad.lat).to eq(lat)
    #     expect(ad.lon).to eq(lon)
    #   end
    # end
  
  #   context 'missing city' do
  #     before do
  #       allow_any_instance_of(GeoService::Api).to receive(:coord)
  #         .with('City 17')
  #         .and_return(nil)
  #     end

  #     let(:ad_params) do
  #       {
  #         title: 'Ad title',
  #         description: 'Ad description',
  #         city: 'City 17',
  #         user_id: 1
  #       }
  #     end
  
  #     it 'does not update ad coordinates' do
  #       post '/ads', ad: ad_params
  
  #       ad = Ad.last  
  #       expect(ad.lat).to be_nil
  #       expect(ad.lon).to be_nil
  #     end
  #   end
  # end

  # describe 'POST /ads (invalid auth token)' do
  #   let(:ad_params) do
  #     {
  #       title: 'Ad title',
  #       description: 'Ad description',
  #       city: 'City'
  #     }
  #   end

  #   it 'returns an error' do
  #     post '/ads', params: { ad: ad_params }

  #     expect(response).to have_http_status(:forbidden)
  #     expect(response_body['errors']).to include('detail' => 'Доступ к ресурсу ограничен')
  #   end
  # end
end

require 'rails_helper'

model = 'User'
RSpec.describe "#{model.pluralize}", type: :request do
  let(:enterprise) { create(:enterprise) }
  let(:api_key) { create(:api_key) }
  let!(:user) { create(:user, password: 'password', enterprise: enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let!(:item) { create(model.constantize.table_name.singularize.to_sym) }
  let(:route) { 'user' }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key, 'Diverst-UserToken' => jwt } }

  describe '#get_user_data' do
    before { get "/api/v1/#{route}/user_data", headers: headers }
    it 'returns :ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'has all permissions' do
      body = JSON.parse(response.body)
      expect(body['permissions']).to_not be_nil
      expect(body['permissions']).to_not be_empty
      expect(body['permissions'].values).to all(be_truthy)
    end
  end
end

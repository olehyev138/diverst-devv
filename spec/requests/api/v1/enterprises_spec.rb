require 'rails_helper'

RSpec.describe 'Enterprise', type: :request do
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, password: 'password', enterprise: enterprise) }
  let(:basic_authentication) { ActionController::HttpAuthentication::Basic.encode_credentials(user.email, 'password') }
  let(:headers) { { 'HTTP_AUTHORIZATION' => basic_authentication } }

  it 'updates a enterprise' do
    patch "/api/v1/enterprises/#{enterprise.id}", enterprise: { name: 'updated' }, headers: headers
    expect(response).to have_http_status(:ok)
  end

  it 'gets the events for an enterprise' do
    get "/api/v1/enterprises/#{enterprise.id}/events", headers: headers
    expect(response).to have_http_status(:ok)
  end
end

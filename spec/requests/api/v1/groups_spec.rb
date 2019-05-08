require 'rails_helper'

RSpec.describe 'Group', type: :request do
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, password: 'password', enterprise: enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:basic_authentication) { ActionController::HttpAuthentication::Basic.encode_credentials(user.email, 'password') }
  let(:headers) { { 'HTTP_AUTHORIZATION' => basic_authentication } }

  it 'gets all groups' do
    get '/api/v1/groups', headers: headers
    expect(response).to have_http_status(:ok)
  end

  it 'gets a group' do
    get "/api/v1/groups/#{group.id}", headers: headers
    expect(response).to have_http_status(:ok)
  end

  it 'creates a group' do
    post '/api/v1/groups', group: FactoryBot.attributes_for(:group), headers: headers
    expect(response).to have_http_status(201)
  end

  it 'updates a group' do
    patch "/api/v1/groups/#{group.id}", group: { name: 'updated' }, headers: headers
    expect(response).to have_http_status(:ok)
  end

  it 'deletes a group' do
    delete "/api/v1/groups/#{group.id}", headers: headers
    expect(response).to have_http_status(:no_content)
  end
end

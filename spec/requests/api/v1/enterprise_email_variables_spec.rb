require 'rails_helper'

RSpec.describe 'EnterpriseEmailVariables', type: :request do
  let(:enterprise) { create(:enterprise) }
  let(:api_key) { create(:api_key) }
  let(:user) { create(:user, password: 'password', enterprise: enterprise) }
  let(:item) { create(:enterprise_email_variable) }
  let(:route) { 'enterprise_email_variables' }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key, 'Diverst-UserToken' => jwt } }

  it 'gets all items' do
    get "/api/v1/#{route}", headers: headers
    expect(response).to have_http_status(:forbidden)
  end

  it 'gets a item' do
    get "/api/v1/#{route}/#{item.id}", headers: headers
    expect(response).to have_http_status(:forbidden)
  end

  it 'creates an item' do
    post "/api/v1/#{route}", params: { "#{route.singularize}": build(route.singularize.to_sym).attributes }, headers: headers
    expect(response).to have_http_status(:forbidden)
  end

  it 'updates an item' do
    patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}": item.attributes }, headers: headers
    expect(response).to have_http_status(:forbidden)
  end

  it 'deletes an item' do
    delete "/api/v1/#{route}/#{item.id}", headers: headers
    expect(response).to have_http_status(:forbidden)
  end
end

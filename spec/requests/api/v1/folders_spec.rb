require 'rails_helper'

RSpec.describe 'Folders', type: :request do
  let(:enterprise) { create(:enterprise) }
  let(:api_key) { create(:api_key) }
  let(:user) { create(:user, password: 'password', enterprise: enterprise) }
  let(:password) { SecureRandom.hex(8) }
  let(:item) { create(:folder, password: password, password_protected: true) }
  let(:route) { 'folders' }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key, 'Diverst-UserToken' => jwt } }

  it 'gets all items' do
    get "/api/v1/#{route}", headers: headers
    expect(response).to have_http_status(:ok)
  end

  it 'gets a item' do
    get "/api/v1/#{route}/#{item.id}", headers: headers
    expect(response).to have_http_status(:ok)
  end

  it 'verifies a password' do
    post "/api/v1/#{route}/#{item.id}/password", params: { password: password }, headers: headers
    expect(response).to have_http_status(:ok)
  end

  it 'raises an error with invalid password' do
    folder = create(:folder)
    post "/api/v1/#{route}/#{folder.id}/password", params: { password: 'fake' }, headers: headers
    expect(response).to have_http_status(:bad_request)
  end

  it 'creates an item' do
    post "/api/v1/#{route}", params: { "#{route.singularize}": build(route.singularize.to_sym).attributes }, headers: headers
    expect(response).to have_http_status(201)
  end

  it 'updates an item' do
    patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}": item.attributes }, headers: headers
    expect(response).to have_http_status(:ok)
  end

  it 'deletes an item' do
    delete "/api/v1/#{route}/#{item.id}", headers: headers
    expect(response).to have_http_status(:no_content)
  end
end

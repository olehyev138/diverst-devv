require 'rails_helper'

model = 'Enterprise'
RSpec.describe "#{model.pluralize}", type: :request do
  let!(:item) { create(model.constantize.table_name.singularize.to_sym, idp_sso_target_url: 'http://example.com') }
  let(:api_key) { create(:api_key) }
  let(:user) { create(:user, password: 'password', enterprise: item) }
  let(:route) { model.constantize.table_name }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key, 'Diverst-UserToken' => jwt } }

  describe '#index' do
    it 'gets all items' do
      get "/api/v1/#{route}", headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:index).and_raise(BadRequestException)
      get "/api/v1/#{route}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#show' do
    it 'gets the current users enterprise' do
      get "/api/v1/#{route}", headers: headers

      json_response = JSON.parse(response.body)
      expect(json_response['page']['items'][0]['id']).to eq(user.enterprise.id)
    end
  end

  describe '#create' do
    it 'creates an item' do
      post "/api/v1/#{route}", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(201)
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:build).and_raise(BadRequestException)
      post "/api/v1/#{route}", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    include_examples 'InvalidInputException when creating', model
  end

  describe '#update' do
    it 'updates an item' do
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => item.attributes }, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error when BadRequestException' do
      allow(model.constantize).to receive(:update).and_raise(BadRequestException)
      patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => item.attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end

    include_examples 'InvalidInputException when updating', model
  end

  describe '#destroy' do
    it 'deletes an item' do
      delete "/api/v1/#{route}/#{item.id}", headers: headers
      Clipboard.copy response.parsed_body.to_json
      expect(response).to have_http_status(:no_content)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:destroy).and_raise(BadRequestException)
      delete "/api/v1/#{route}/#{item.id}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#sso_login' do
    it 'returns link to login page with error message' do
      post "/api/v1/#{route}/#{item.id}/sso_login", params: {}, headers: headers
      expect(response).to redirect_to "#{ENV['DOMAIN']}/login?errorMessage=Response cannot be nil"
    end

    it 'returns link with user token for existing user' do
      saml = OpenStruct.new({ is_valid?: true, nameid: user.email, attributes: {} })
      allow(OneLogin::RubySaml::Response).to receive(:new).and_return(saml)

      post "/api/v1/#{route}/#{item.id}/sso_login", params: {}, headers: headers
      expect(response.header['Location']).to include 'userToken', 'policyGroupId'
    end

    it 'returns link with user token for new user' do
      saml = OpenStruct.new({ is_valid?: true, nameid: 'test@gmail.com', attributes: {} })
      allow(OneLogin::RubySaml::Response).to receive(:new).and_return(saml)

      post "/api/v1/#{route}/#{item.id}/sso_login", params: {}, headers: headers
      expect(response.header['Location']).to include 'userToken', 'policyGroupId'
    end

    it 'returns a link to login page because there are errors in the response' do
      domain = ENV['DOMAIN'] || 'http://www.example.com'
      saml = OpenStruct.new({ is_valid?: false, nameid: 'test@gmail.com', attributes: {}, errors: ['Actual Audience does not match expected audience'] })
      allow(OneLogin::RubySaml::Response).to receive(:new).and_return(saml)

      post "/api/v1/#{route}/#{item.id}/sso_login", params: {}, headers: headers
      expect(response.header['Location']).to eq "#{domain}/login?errorMessage=Actual Audience does not match expected audience"
    end
  end

  describe '#sso_link' do
    it 'returns link to sso login page' do
      post "/api/v1/#{route}/#{item.id}/sso_link", params: {}, headers: headers
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('http://example.com?SAMLRequest=')
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:sso_link).and_raise(BadRequestException)
      post "/api/v1/#{route}/#{item.id}/sso_link", params: {}, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end
end

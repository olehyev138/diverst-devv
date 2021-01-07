require 'rails_helper'

model = 'Enterprise'
RSpec.describe "#{model.pluralize}", type: :request do
  let!(:item) { create(model.constantize.table_name.singularize.to_sym, idp_sso_target_url: 'http://example.com') }
  let(:api_key) { create(:api_key) }
  let(:user) { create(:user, password: 'password', enterprise: item) }
  let(:route) { model.constantize.table_name }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key, 'Diverst-UserToken' => jwt } }
  let(:field) { create(:field, type: 'NumericField') }

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

  describe '#fields' do
    it 'gets fields' do
      get "/api/v1/#{route}/#{item.id}/fields", params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error' do
      allow_any_instance_of(model.constantize).to receive(:fields).and_raise(BadRequestException)
      get "/api/v1/#{route}/#{item.id}/fields", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#create field' do
    it 'creates fields' do
      post "/api/v1/#{route}/#{item.id}/create_field", params: { 'field': field.attributes }, headers: headers
      expect(response).to have_http_status(:created)
    end

    it 'captures the error' do
      allow_any_instance_of(model.constantize).to receive(:fields).and_raise(BadRequestException)
      post "/api/v1/#{route}/#{item.id}/create_field", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#get_auth_enterprise' do
    it 'gets the authorized enterprise' do
      get "/api/v1/#{route}/get_auth_enterprise", params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error' do
      forced_user_load = user
      allow_any_instance_of(ActiveRecord::Relation).to receive(:first).and_raise(BadRequestException)
      get "/api/v1/#{route}/get_auth_enterprise", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#get_enterprise' do
    it 'gets the enterprise' do
      get "/api/v1/#{route}/get_enterprise", params: {}, headers: headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#update enterprise' do
    it 'update the enterprise' do
      post "/api/v1/#{route}/update_enterprise", params: { "#{route.singularize}" => item.attributes }, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      get "/api/v1/#{route}/update_enterprise", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#update sso' do
    it 'update the sso settings' do
      put "/api/v1/#{route}/update_sso", params: { "#{route.singularize}" => {
          'id' => 1,
          'idp_entity_id' => 'https://app.onelogin.com/saml/entry',
          'idp_sso_target_url' => 'https://v7.onelogin.com/trust/saml2/sso',
          'idp_slo_target_url' => 'https://v7.onelogin.com/trust/saml2/slo',
          'idp_cert' => "-----BEGIN CERTIFICATE-----\n  -----END CERTIFICATE-----\n",
          'sp_entity_id' => 'ID',
          'has_enabled_saml' => false,
      } }, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      get "/api/v1/#{route}/update_sso", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#update branding' do
    it 'update the branding settings' do
      put "/api/v1/#{route}/update_branding", params: { "#{route.singularize}" => {
          'id' => item.id,
          'home_message' => 'home_message',
          'onboarding_consent_enabled' => true,
          'onboarding_consent_message' => 'onboarding_consent_message',
          'privacy_statement' => 'privacy_statement',
          'theme_attributes' => {
            'primary_color' => 'FFFFFF',
            'secondary_color' => '000000',
            'use_secondary_color' => true,
          },
      } }, headers: headers
      expect(response).to have_http_status(:ok)
      item.reload
      expect(item.home_message).to eq('home_message')
      expect(item.onboarding_consent_enabled).to eq(true)
      expect(item.onboarding_consent_message).to eq('onboarding_consent_message')
      expect(item.privacy_statement).to eq('privacy_statement')
      expect(item.theme.primary_color).to eq('FFFFFF')
      expect(item.theme.secondary_color).to eq('000000')
      expect(item.theme.use_secondary_color).to eq(true)
    end

    it 'captures the error' do
      allow(model.constantize).to receive(:find).and_raise(BadRequestException)
      get "/api/v1/#{route}/update_branding", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end
end

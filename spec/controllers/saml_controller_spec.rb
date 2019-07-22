require 'rails_helper'

RSpec.describe SamlController, type: :controller do
  let(:enterprise) { create(:enterprise, idp_sso_target_url: 'http://example.com') }
  let(:user) { create(:user, enterprise: enterprise) }

  describe 'GET#index' do
    before { get :index, enterprise_id: enterprise.id }

    it 'render index template' do
      expect(response).to render_template :index
    end

    it 'sets a valid enterprise object' do
      expect(assigns[:enterprise]).to be_valid
    end
  end


  describe 'GET#sso' do
    it 'renders no settings' do
      allow_any_instance_of(Enterprise).to receive(:saml_settings).and_return(nil)
      request.env['HTTP_REFERER'] = 'back'

      get :sso, enterprise_id: enterprise.id
      expect(response).to redirect_to 'back'
    end

    it 'redirects to idp_sso_target_url' do
      get :sso, enterprise_id: enterprise.id

      expect(response.code).to eq('302')
      expect(response.location).to include('http://example.com?SAMLRequest=')
    end

    it 'sets a valid enterprise object' do
      get :sso, enterprise_id: enterprise.id
      expect(assigns[:enterprise]).to be_valid
    end
  end


  describe 'POST#acs' do
    it 'gets acs' do
      saml = OpenStruct.new({ is_valid?: true, nameid: user.email, attributes: {} })
      allow(OneLogin::RubySaml::Response).to receive(:new).and_return(saml)

      get :acs, enterprise_id: enterprise.id, SAMLResponse: 'test'
      expect(response).to redirect_to user_root_path
    end

    it 'gets acs and create user' do
      saml = OpenStruct.new({ is_valid?: true, nameid: 'test@gmail.com', attributes: {} })
      allow(OneLogin::RubySaml::Response).to receive(:new).and_return(saml)

      get :acs, enterprise_id: enterprise.id, SAMLResponse: 'test'
      expect(response).to redirect_to onboarding_index_path
      expect(User.last.email).to eq('test@gmail.com')
    end

    it 'render fail' do
      saml = OpenStruct.new({ is_valid?: false, nameid: 'test@gmail.com', attributes: {} })
      allow(OneLogin::RubySaml::Response).to receive(:new).and_return(saml)

      get :acs, enterprise_id: enterprise.id, SAMLResponse: 'test'
      expect(response).to render_template :fail
    end
  end


  describe 'GET#metadata' do
    before { get :metadata, enterprise_id: enterprise.id }

    it 'gets metadata' do
      expect(response).to be_success
    end

    it 'sets a valid enterprise object' do
      expect(assigns[:enterprise]).to be_valid
    end
  end


  describe 'GET#logout' do
    it 'gets SAMLRequest logout and returns an error' do
      get :logout, enterprise_id: enterprise.id, SAMLRequest: 'test', RelayState: 'Test'
      expect(response).to be_success
    end

    it 'gets SAMLRequest logout' do
      saml_request = OpenStruct.new({ is_valid?: true, create: true })
      allow(OneLogin::RubySaml::SloLogoutrequest).to receive(:new).and_return(saml_request)
      saml_response = OpenStruct.new({ create: true })
      allow(OneLogin::RubySaml::SloLogoutresponse).to receive(:new).and_return(saml_response)
      allow(saml_response).to receive(:create).and_return('test')

      get :logout, enterprise_id: enterprise.id, SAMLRequest: 'test', RelayState: 'Test'
      expect(response).to redirect_to 'test'
    end

    it 'gets SAMLResponse logout' do
      get :logout, enterprise_id: enterprise.id, SAMLResponse: 'test'
      expect(response).to be_success
    end

    it 'gets SAMLResponse logout' do
      saml_response = OpenStruct.new({ validate: true, success?: true })
      allow(OneLogin::RubySaml::Logoutresponse).to receive(:new).and_return(saml_response)

      get :logout, enterprise_id: enterprise.id, SAMLResponse: 'test'
      expect(response).to be_success
    end

    it 'gets sp_logout_request and resets session' do
      get :logout, enterprise_id: enterprise.id, slo: ''
      expect(response).to be_success
    end

    it 'gets sp_logout_request and redirects' do
      enterprise.idp_slo_target_url = 'test'
      enterprise.save

      logout_request = OneLogin::RubySaml::Logoutrequest.new
      allow(OneLogin::RubySaml::Logoutrequest).to receive(:new).and_return(logout_request)
      allow(logout_request).to receive(:create).and_return('link')

      get :logout, enterprise_id: enterprise.id, slo: ''
      expect(response).to redirect_to('link')
    end

    it 'gets regular logout' do
      get :logout, enterprise_id: enterprise.id
      expect(response).to be_success
    end

    it 'sets a valid enterprise object' do
      get :logout, enterprise_id: enterprise.id
      expect(assigns[:enterprise]).to be_valid
    end
  end
end

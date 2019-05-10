require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  include ActiveJob::TestHelper

  let(:enterprise) { create(:enterprise, has_enabled_saml: true) }
  let(:user) { create(:user, password: 'password', enterprise: enterprise) }

  before :each do
    session[:saml_for_enterprise] = user.enterprise.id
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET#new' do
    xit 'redirect_to sso_enterprise_saml_index_url' do
      get :new
      expect(response).to redirect_to sso_enterprise_saml_index_url(enterprise_id: enterprise.id)
    end

    it 'redirect_to sso_enterprise_saml_index_url' do
      enterprise.has_enabled_saml = false
      enterprise.save!
      get :new
      expect(response).to be_success
    end
  end

  describe 'POST#create' do
    it 'flashes invalid credentials' do
      post :create
      expect(flash[:alert]).to eq 'Invalid email or password.'
    end

    it 'flashes message for users with pending invitation' do
      user.invitation_accepted_at = nil
      user.save

      post :create, user: { email: user.email, password: 'password' }
      expect(flash[:alert]).to eq 'You have a pending invitation. Please check your email to accept the invitation and sign in'
    end

    it 'signs user in' do
      perform_enqueued_jobs do
        expect_any_instance_of(User).to receive(:create_activity)
        enterprise.has_enabled_saml = false
        enterprise.save!

        post :create, user: { email: user.email, password: 'password' }
        expect(flash[:notice]).to eq 'Signed in successfully.'
      end
    end
  end
end

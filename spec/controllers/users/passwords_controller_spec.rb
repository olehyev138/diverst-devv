require 'rails_helper'

RSpec.describe Users::PasswordsController, type: :controller do
  let(:user){ create(:user) }

  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST#create' do
    it 'renders success' do
      post :create
      expect(response).to redirect_to '/users/sign_in'
    end

    it 'flashes invite message when user hasnt accepted' do
      user.invitation_accepted_at = nil
      user.save

      post :create, { user: { email: user.email } }
      expect(flash[:notice]).to eq('You have a pending invitation. Please check your email to accept the invitation and sign in')
    end

    it 'flashes password reset message when user has accepted' do
      post :create, email: user.email
      expect(flash[:notice]).to eq('You will recieve an email shortly')
    end

    it 'flashes password reset message when user doesnt exist' do
      post :create
      expect(flash[:notice]).to eq('You will recieve an email shortly')
    end
  end
end

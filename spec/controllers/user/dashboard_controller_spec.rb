require 'rails_helper'

RSpec.describe User::DashboardController, type: :controller do
  let(:user) { create :user }

  describe 'GET social' do
    def get_social
      get :social
    end

    context 'with logged in user' do
      login_user_from_let

      it 'returns success' do
        expect(response).to be_success
      end

      it 'renders correct template' do
        expect(response).to render_template :social
      end
    end

    context 'without logged in user' do
      before { get_social }

      it 'returns an error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'GET #home' do
    it 'should be implemented'
  end

  describe 'GET #rewards' do
    it 'should be implemented'
  end
end

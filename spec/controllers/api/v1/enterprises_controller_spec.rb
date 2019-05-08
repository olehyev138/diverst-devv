require 'rails_helper'

RSpec.describe Api::V1::EnterprisesController, type: :controller do
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise, password: 'password') }

  context 'without authentication' do
    describe 'GET#events' do
      it 'gets the group' do
        get :events, id: 1
        expect(response).to_not be_success
        expect(response.status).to be(400)
      end
    end

    describe 'PATCH#update' do
      it 'updates the enterprise' do
        patch :update, id: 1
        expect(response).to_not be_success
        expect(response.status).to be(400)
      end
    end
  end

  context 'with authentication' do
    before :each do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email, 'password')
    end

    describe 'GET#events' do
      it "gets the enterprise's events" do
        get :events, id: enterprise.id
        expect(response).to be_success
        expect(response.status).to be(200)
      end
    end

    describe 'PATCH#update' do
      it 'updates the enterprise' do
        patch :update, id: enterprise.id, enterprise: { name: 'updated' }
        expect(response).to be_success
        expect(response.status).to be(200)
      end
      it 'renders 422' do
        allow_any_instance_of(Enterprise).to receive(:update_attributes).and_return(false)
        patch :update, id: enterprise.id, enterprise: { name: 'updated' }
        expect(response).to_not be_success
        expect(response.status).to be(422)
      end
    end
  end
end

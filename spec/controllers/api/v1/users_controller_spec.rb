require 'rails_helper'
require 'spec_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise, password: 'password') }

  context 'without authorization' do
    describe 'GET#index' do
      it 'gets the users' do
        get :index
        expect(response).to_not be_success
        expect(response.status).to be(400)
      end
    end

    describe 'GET#show' do
      it 'gets the user' do
        get :show, id: 1
        expect(response).to_not be_success
        expect(response.status).to be(400)
      end
    end

    describe 'POST#create' do
      it 'creates the user' do
        post :create
        expect(response).to_not be_success
        expect(response.status).to be(400)
      end
    end

    describe 'PATCH#update' do
      it 'updates the user' do
        patch :update, id: 1
        expect(response).to_not be_success
        expect(response.status).to be(400)
      end
    end

    describe 'DELETE#destroy' do
      it 'deletes the user' do
        delete :destroy, id: 1
        expect(response).to_not be_success
        expect(response.status).to be(400)
      end
    end
  end

  context 'with authorization' do
    before :each do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email, 'password')
    end

    describe 'GET#index' do
      it 'gets the users' do
        get :index
        expect(response).to be_success
        expect(response.status).to be(200)
      end
    end

    describe 'GET#show' do
      it 'gets the user' do
        get :show, id: user.id
        expect(response).to be_success
        expect(response.status).to be(200)
      end
    end

    describe 'POST#create' do
      it 'creates the user' do
        post :create, user: { email: 'test@gmail.com', password: 'password', first_name: 'Mike', last_name: 'Smith' }
        expect(response).to be_success
        expect(response.status).to be(201)
      end

      it 'returns 422' do
        allow_any_instance_of(User).to receive(:save).and_return(false)
        post :create, user: { email: 'test@gmail.com', password: 'password', first_name: 'Mike', last_name: 'Smith' }
        expect(response.status).to eq 422
      end
    end

    describe 'PATCH#update' do
      it 'updates the user' do
        patch :update, id: user.id, user: { first_name: 'Mike' }

        expect(response).to be_success
        expect(response.status).to be(200)
      end

      it 'returns 422' do
        allow_any_instance_of(User).to receive(:update_attributes).and_return(false)
        patch :update, id: user.id, user: { first_name: 'Mike' }
        expect(response.status).to eq 422
      end
    end

    describe 'DELETE#destroy' do
      let!(:another_user) { create(:user, enterprise: enterprise) }
      it 'deletes the user' do
        delete :destroy, id: another_user.id
        expect(response).to be_success
        expect(response.status).to be(204)
      end
    end
  end
end

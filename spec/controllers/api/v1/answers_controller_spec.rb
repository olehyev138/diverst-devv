require 'rails_helper'

RSpec.describe Api::V1::AnswersController, type: :controller do

  let(:api_key) { FactoryBot.create(:api_key) }
  let(:enterprise) { FactoryBot.create(:enterprise) }
  let(:user) { FactoryBot.create(:user, enterprise: enterprise) }
  let(:item) { FactoryBot.create(:answer) }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:valid_session) { { 'Diverst-APIKey' => api_key.key, 'Diverst-UserToken' => jwt } }

  before :each do
    request.headers.merge!(valid_session) # Add to request headers
  end

  describe 'GET #index' do
    context 'gets the items' do
      before do
        get :index, params: {}
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST #create' do
    context 'creates the item' do
      before do
        question = create(:question)
        group = create(:group)
        payload = {
          author_id: user.id,
          question_id: question.id,
          content: "test",
          contributing_group_id: group.id
        }
        post :create, params: { answer: payload }
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'PUT #update' do
    context 'updates the item' do
      before do
        put :update, params: { id: item.id, answer: { content: 'updated' } }
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'deletes the item' do
      before do
        delete :destroy, params: { id: item.id }
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end
end

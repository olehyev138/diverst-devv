require 'rails_helper'

RSpec.describe Api::V1::GroupLeadersController, type: :controller do

  let(:api_key) { FactoryBot.create(:api_key) }
  let(:enterprise) { FactoryBot.create(:enterprise) }
  let(:user) { FactoryBot.create(:user, enterprise: enterprise) }
  let(:group) { FactoryBot.create(:group, enterprise: enterprise) }
  let(:group_leader_role) { enterprise.user_roles.where(role_type: 'group').first }
  let(:group_leader) { FactoryBot.create(:group_leader, user: user, group: group, user_role_id: group_leader_role.id) }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:valid_session) { { 'Diverst-APIKey' => api_key.key, 'Diverst-UserToken' => jwt } }

  before :each do
    request.headers.merge!(valid_session) # Add to request headers
  end

  describe 'GET #index' do
    context 'gets the group_leaders' do
      before do
        get :index, params: {}
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST #create' do
    context 'creates a group_leader' do
      before do
        user2 = create(:user, enterprise: enterprise)
        create(:user_group, group: group, user: user2)
        payload = {
            user_id: user2.id,
            group_id: group.id,
            user_role_id: group_leader_role.id,
            position_name: 'Super Leader'
        }
        post :create, params: { group_leader: payload }
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'PUT #update' do
    context 'updates a group_leader' do
      before do
        put :update, params: { id: group_leader.id, group_leader: { position_name: 'name' } }
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'deletes a group_leader' do
      before do
        delete :destroy, params: { id: group_leader.id }
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end
end

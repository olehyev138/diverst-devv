require 'rails_helper'

RSpec.describe Groups::LeadersController, type: :controller do
  describe 'GET #index' do
    def get_index(group_id=-1)
      get :index, group_id: group_id
    end

    context 'with logged in user' do
      let(:user) { create :user }
      login_user_from_let

      context 'with correct group' do
        let!(:group) { create(:group, enterprise: user.enterprise) }
        let!(:group_leader) { create :group_leader, group: group }
        let!(:other_leader) { create :group_leader }

        before { get_index(group.to_param) }

        it 'returns success' do
          expect(response).to be_success
        end

        it 'assigns correct leaders' do
          leaders = assigns(:leaders)

          expect(leaders).to include(group_leader.user)
          expect(leaders).to_not include(other_leader.user)
        end
      end

      context 'with incorrect group' do
        before { get_index }

        xit 'returns error' do
          expect(response).to_not be_success
        end
      end
    end

    context 'without logged in user' do
      let(:group) { create(:group) }

      before { get_index(group.to_param) }

      it 'returns error' do
        expect(response).to_not be_success
      end
    end
  end
end

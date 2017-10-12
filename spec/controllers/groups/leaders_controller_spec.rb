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
          leaders = assigns(:group_leaders).map { |gl| gl.user }

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

  describe 'GET #new' do
    def get_new(group_id = nil)
      get :new, group_id: group_id
    end

    context 'with logged in user' do
      let(:user) { create(:user) }
      login_user_from_let

      context 'with group_id' do
        let(:group) { create(:group, enterprise: user.enterprise) }

        before { get_new(group.to_param)}

        it 'sets @group correctly' do
          group = assigns(:group)
          expect(group).to be_a Group
          expect(group).to eq group
        end

        it 'renders correct template' do
          expect(response).to render_template(:new)
        end

        it 'returns success' do
          expect(response).to be_success
        end
      end

      context 'without group id' do
        before { get_new }

        xit 'returns error' do
          expect(response).to_not be_success
        end
      end
    end

    context 'without logged in user' do
      let(:group) { create(:group) }

      before { get_new(group.to_param) }

      xit 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'POST #create' do
    def post_create(group_id=-1, params={a: 1})
      post :create, group_id: group_id, group: { group_leaders_attributes: { "0": params } }
    end

    context 'with logged in user' do
      let(:user) { create :user }
      login_user_from_let

      let!(:group) { create :group, enterprise: user.enterprise }

      let(:leader_user) { create :user }
      let(:leader_attrs) { attributes_for :group_leader, user_id: leader_user.to_param }

      context 'with correct params' do
        it 'updates group leaders of a group' do
          expect{
            post_create(group.to_param, leader_attrs)
          }.to change(group.group_leaders, :count).by(1)
        end

        it 'redirects to correct action' do
          post_create(group.to_param, leader_attrs)
          expect(response).to redirect_to action: :index
        end
        
        it 'sets attributes' do
          post_create(group.to_param, leader_attrs)
          leader = group.group_leaders.first
          expect(leader.notifications_enabled).to eq(false)
        end
      end

      context 'with incorrect params' do
        let(:leader_attrs){ attributes_for :group_leader, position_name: "", user_id: leader_user.to_param }
        it 'does not save the new leader' do
          expect{ post_create(group.to_param, leader_attrs) }
            .to_not change(group.group_leaders, :count)
        end

        it 'renders new view' do
          post_create(group.to_param, leader_attrs)
          expect(response).to render_template :new
        end
      end
    end

    context 'without logged in user' do
      before { post_create }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Groups::LeadersController, type: :controller do
  describe 'GET #index' do
    def get_index(group_id = -1)
      get :index, group_id: group_id
    end

    context 'with logged in user' do
      let(:enterprise) { create :enterprise }
      let(:user) { create :user, enterprise: enterprise }
      let(:user1) { create :user, enterprise: enterprise }
      let(:user2) { create :user, enterprise: enterprise }
      login_user_from_let

      context 'with correct group' do
        let!(:group) { create(:group, enterprise: user.enterprise) }
        let!(:group_membership) { create(:user_group, group: group, user: user1, accepted_member: true) }
        let!(:group_leader) { create :group_leader, group: group, user: user1 }
        let!(:other_group_membership) { create :user_group, user: user2, group: create(:group, enterprise: enterprise) }

        before { get_index(group.to_param) }

        it 'render index template' do
          expect(response).to render_template :index
        end

        it 'assigns correct leaders' do
          leaders = assigns(:group_leaders).map { |gl| gl.user }

          expect(leaders).to include(user1)
          expect(leaders).to_not include(user2)
        end
      end
    end

    context 'without logged in user' do
      let(:group) { create(:group) }
      before { get_index(group.to_param) }
      it_behaves_like 'redirect user to users/sign_in path'
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

        before { get_new(group.to_param) }

        it 'sets @group correctly' do
          group = assigns(:group)
          expect(group).to be_a Group
          expect(group).to eq group
        end

        it 'renders correct template' do
          expect(response).to render_template(:new)
        end
      end
    end

    context 'without logged in user' do
      let(:group) { create(:group) }
      before { get_new(group.to_param) }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'POST #create' do
    def post_create(group_id = -1, params = { a: 1 })
      post :create, group_id: group_id, group: { group_leaders_attributes: { "0": params } }
    end

    context 'with logged in user' do
      let(:enterprise) { create :enterprise }
      let(:user) { create :user, enterprise: enterprise }
      login_user_from_let

      let!(:group) { create :group, enterprise: enterprise }

      let!(:leader_user) { create :user, enterprise: enterprise }
      let!(:group_membership) { create(:user_group, user: leader_user, group: group, accepted_member: true) }
      let!(:leader_attrs) { attributes_for :group_leader, user_id: leader_user.id, group_id: group.id,
                                                          position_name: 'Admin', user_role_id: leader_user.enterprise.user_roles.where(role_name: 'group_leader').first.id
      }

      context 'with correct params' do
        it 'updates group leaders of a group' do
          expect {
            post_create(group.to_param, leader_attrs)
          }.to change(group.group_leaders, :count).by(1)
        end

        it 'flashes a notice message' do
          post_create(group.to_param, leader_attrs)
          expect(flash[:notice]).to eq 'Leaders were updated'
        end

        it 'redirects to correct action' do
          post_create(group.to_param, leader_attrs)
          expect(response).to redirect_to action: :index
        end

        it 'sets attributes' do
          post_create(group.to_param, leader_attrs)
          leader = group.group_leaders.first
          expect(leader.pending_member_notifications_enabled).to eq(false)
        end
      end

      context 'with incorrect params' do
        let(:leader_attrs) { attributes_for :group_leader, position_name: '', user_id: leader_user.to_param, user_role_id: leader_user.enterprise.user_roles.where(role_name: 'group_leader').first }

        it 'does not save the new leader' do
          expect { post_create(group.to_param, leader_attrs) }
            .to_not change(group.group_leaders, :count)
        end

        it 'renders new view' do
          post_create(group.to_param, leader_attrs)
          expect(response).to render_template :new
        end

        it 'flashes an alert message' do
          post_create(group.to_param, leader_attrs)
          expect(flash[:alert]).to eq 'Leaders were not updated. Please fix the errors'
        end
      end
    end

    context 'without logged in user' do
      before { post_create }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end

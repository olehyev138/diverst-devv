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

  describe 'GET #edit' do
    let(:user) { create :user }
    let(:group) { create :group, enterprise: user.enterprise }
    let!(:group_leader) { create :group_leader, group: group }

    def get_edit(group_id=-1, id=-1)
      get :edit, group_id: group_id, id: id
    end

    context 'with logged user' do
      login_user_from_let

      before { get_edit(group.to_param, group_leader.to_param) }

      it 'return success' do
        expect(response).to be_success
      end

      it 'assigns correct group leader' do
        expect(assigns(:group_leader)).to eq group_leader
      end

      it 'renders correct template' do
        expect(response).to render_template :edit
      end
    end

    context 'without logged user' do
      before { get_edit(group.to_param, group_leader.to_param) }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'POST #create' do
    def post_create(group_id=-1, params={a: 1})
      post :create, group_id: group_id, group_leader: params
    end

    context 'with logged in user' do
      let(:user) { create :user }
      login_user_from_let

      let!(:group) { create :group, enterprise: user.enterprise }

      let(:leader_user) { create :user }
      let(:leader_attrs) { attributes_for :group_leader, user_id: leader_user.to_param }

      context 'with correct params' do
        it 'creates group leader' do
          expect{
            post_create(group.to_param, leader_attrs)
          }.to change(GroupLeader, :count).by(1)
        end

        it 'creates correct leader' do
          post_create(group.to_param, leader_attrs)

          new_leader = GroupLeader.last

          expect(new_leader.position_name).to eq leader_attrs[:position_name]
          expect(new_leader.user).to eq leader_user
        end

        it 'redirects to correct action' do
          post_create(group.to_param, leader_attrs)
          expect(response).to redirect_to action: :index
        end
      end

      context 'with incorrect params' do
        it 'does not save the new leader' do
          expect{ post_create(group.to_param) }
            .to_not change(GroupLeader, :count)
        end

        it 'renders new view' do
          post_create(group.to_param)
          expect(response).to render_template :new
        end

        it 'shows error' do
          post_create(group.to_param )
          group_leader = assigns(:leader)

          expect(group_leader.errors).to_not be_empty
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

  describe 'PATCH #update' do
    def patch_update(group_id=-1, id=-1, params = {a: :b})
      patch :update, group_id: group_id, id: id, group_leader: params
    end

    context 'with logged in user' do
      let(:user) { create :user }
      let(:group) { create :group, enterprise: user.enterprise }
      let!(:group_leader) { create :group_leader, group: group }
      let!(:old_position_name) { group_leader.position_name }

      login_user_from_let

      context 'with correct params' do
        let(:new_params) { attributes_for :group_leader }

        before { patch_update(group.to_param, group_leader.to_param, new_params) }

        it 'updates fields' do
          expect(group_leader.reload.position_name).to eq new_params[:position_name]
        end

        it 'redirects to correct action' do
          expect(response).to redirect_to action: :index
        end
      end

      context 'with incorrect params' do
        before { patch_update(group.to_param, group_leader.to_param, {position_name: ''}) }

        it 'does not update fields' do
          expect(group_leader.reload.position_name).to eq old_position_name
        end

        it 'redirects to edit action' do
          expect(response).to render_template :edit
        end

        it 'shows errors' do
          group_leader = assigns(:group_leader)

          expect(group_leader.errors).to_not be_empty
        end
      end
    end

    context 'without logged in user' do
      let(:group) { create :group}

      before { patch_update(group.id) }

      it 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    def delete_destroy(group_id = -1, id=-1)
      delete :destroy, group_id: group_id, id: id
    end

    let(:user) { create :user }
    let!(:group) { create :group, enterprise: user.enterprise }
    let!(:group_leader) { create :group_leader, group: group }

    context 'with logged in user' do
      login_user_from_let

      context 'with correct params' do
        it 'deletes leader' do
          expect{
            delete_destroy(group.to_param, group_leader.to_param)
          }.to change(GroupLeader, :count).by(-1)
        end

        it 'redirects to correct action' do
          delete_destroy(group.to_param, group_leader.to_param)

          expect(response).to redirect_to  action: :index
        end
      end
    end

    context 'without logged in user' do
      it 'return error' do
        delete_destroy(group.to_param, group_leader.to_param)
        expect(response).to_not be_success
      end

      it 'do not change Group Leader count' do
        expect {
          delete_destroy(group.to_param, group_leader.to_param)
        }.to_not change(GroupLeader, :count)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe User::GroupsController, type: :controller do

  let!(:user) { create :user }
  let!(:group) { create(:group, enterprise: user.enterprise, owner: user, private: true) }

  before {
    group.children << Group.create!(name: 'child', enterprise: group.enterprise)
  }

  describe 'GET #index' do
    describe 'when user is logged in' do
      login_user_from_let

      context 'when group has no parents and is private' do
        before { get :index }

        it 'render index template' do
          expect(response).to render_template :index
        end

        it "return 1 of the current user's enterprise groups" do
          expect(assigns[:groups]).to eq [group]
        end
      end
    end

    describe 'when user is not logged in' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET #join' do
    describe 'when user is logged in' do
      context 'when group has pending_users enabled' do
        login_user_from_let
        before do
          @enabled_group = create(:group, enterprise: user.enterprise, pending_users: 'enabled')
          params = { id: @enabled_group.id }
          get :join, params
        end

        it 'join group' do
          expect(assigns[:group].members).to eq [user]
        end

        it 'accepts member' do
          expect(UserGroup.where(group_id: @enabled_group.id, user_id: user.id, accepted_member: false).exists?).to be (true)
        end
      end

      context 'when group has pending_users disabled' do
        login_user_from_let
        before do
          @disabled_group = create(:group, enterprise: user.enterprise, pending_users: 'disabled')
          params = { id: @disabled_group.id }
          get :join, params
        end

        it 'join group' do
          expect(assigns[:group].members).to eq [user]
        end

        it 'accepts member' do
          expect(UserGroup.where(group_id: @disabled_group.id, user_id: user.id, accepted_member: true).exists?).to be (true)
        end
      end
    end

    describe 'when user is not logged in' do
      before do
        params = { id: group.id }
        get :join, params
      end
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end

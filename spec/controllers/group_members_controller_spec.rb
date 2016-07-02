require 'rails_helper'

RSpec.describe Groups::GroupMembersController, type: :controller do
  describe 'GET #index' do
    def get_index(group_id = nil)
      get :index, group_id: group_id
    end

    context 'with logged in user' do
      let(:user) {FactoryGirl.create(:user)}
      login_user_from_let

      context 'with correct group' do
        let(:group) { FactoryGirl.create(:group, enterprise: user.enterprise)}

        before { get_index(group.to_param) }

        it 'return success' do
          expect(response).to be_success
        end

        it 'renders correct template' do
          expect(response).to render_template :index
        end

        xit 'sets @members'
      end

      context 'with incorect group'
    end

    context 'without logged in user' do
    end
  end

  describe 'GET #new' do
    def get_new(group_id = nil)
      get :new, group_id: group_id
    end

    context 'with logged in user' do
      let(:user) { FactoryGirl.create(:user) }

      login_user_from_let

      context 'with group_id' do
        let(:group) { FactoryGirl.create(:group, enterprise: user.enterprise) }

        before { get_new(group.to_param)}

        it 'sets @group correctly' do
          group = assigns(:group)
          expect(group).to be_a Group
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
      let(:group) { FactoryGirl.create(:group) }

      before { get_new(group.to_param) }

      xit 'return error' do
        expect(response).to_not be_success
      end
    end
  end

  describe 'POST #add_members' do
    def post_add_members(group_id=nil, ids = [])
      post :add_members, group_id: group_id, group: { member_ids: ids }
    end

    context 'with logged in user' do
      let!(:user) { FactoryGirl.create(:user) }

      login_user_from_let

      context 'with group id' do
        let!(:group) { FactoryGirl.create(:group, enterprise: user.enterprise) }

        context 'with correct params' do
          describe 'new members' do
            let!(:new_users) { FactoryGirl.create_list(:user, 3, enterprise: user.enterprise) }
            let(:new_members_ids) { [new_users[0].to_param, new_users[1].to_param] }

            before { post_add_members group.to_param, new_members_ids }

            it 'adds new members to group' do
                group.reload
                expect(group.members).to include new_users[0]
                expect(group.members).to include new_users[1]
            end

            it 'only adds required members' do
                group.reload
                expect(group.members).to_not include new_users[2]
            end
          end
        end

        context 'with incorrect params' do
          context 'with users from different enterprise' do
            let(:other_enterprise) { FactoryGirl.create(:enterprise) }
            let!(:new_users) { FactoryGirl.create_list(:user, 3, enterprise: other_enterprise) }
            let(:new_members_ids) { [new_users[0].to_param, new_users[1].to_param] }

            it 'does not add users' do
              expect{
                post_add_members group.to_param, new_members_ids
              }.to_not change(group.members, :count)
            end
          end

          context 'with users that are already members of the group' do
            let!(:new_users) { FactoryGirl.create_list(:user, 3, enterprise: user.enterprise) }
            let(:new_members_ids) { [new_users[0].to_param, new_users[1].to_param] }

            before { group.members << new_users[0] }

            it 'does not add duplicate user' do
              expect{
                post_add_members group.id, [new_users[0]]
              }.to_not change(group.members, :count)
            end

            it 'still adds not duplicate users' do
              post_add_members group.id, new_members_ids
              group.reload
              expect(group.members).to include new_users[1]
            end
          end
        end
      end

      context 'with incorrect group id' do
        context 'without group id' do
        end

        context 'with incorrect group id' do
        end
      end
    end

    context 'without logged in user' do
    end
  end

  describe 'DELETE remove_member' do
    def delete_destroy(group_id=nil, member_id=nil)
      delete :remove_member, group_id: group_id, id: member_id
    end

    context 'with logged in user' do
      let(:user) { FactoryGirl.create(:user) }
      login_user_from_let

      context 'with correct group id' do
        let(:group) { FactoryGirl.create(:group, enterprise: user.enterprise)}
        let(:new_member) { FactoryGirl.create(:user, enterprise: user.enterprise)}

        before do
          group.members << new_member
        end

        it 'removes user from group' do
          expect(group.members).to include new_member

          expect{
            delete_destroy(group.to_param, new_member)
          }.to change(group.members, :count).by(-1)

          expect(group.reload.members).to_not include new_member
        end
      end
    end

    context 'without logged in user'

    it 'check if permission check for deletion is correct'
  end
end

require 'rails_helper'

RSpec.describe GroupMessagePolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:second_user){ create(:user, :enterprise => enterprise) }
  let(:group){ create(:group, :enterprise => enterprise) }
  let(:no_access) { create(:user) }
  let!(:group_message){ create(:group_message, :group => group, :owner => second_user)}

  subject { GroupMessagePolicy.new(user, [group, group_message]) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.group_messages_index = false
    no_access.policy_group.group_messages_create = false
    no_access.policy_group.group_messages_manage = false
    no_access.policy_group.save!

    user.policy_group.manage_all = false
    user.policy_group.save!
  }

  describe 'for users with access' do 
    context 'when manage_all is false' do 
      it 'ensure manage_all is false' do 
        expect(user.policy_group.manage_all).to be(false)
      end

      context 'user has groups_manage true' do 
        context 'allows access to index, create' do 
          let!(:group_message) {  nil }
          it { is_expected.to permit_actions([:index, :create]) }
        end

        context 'allows access to edit, update, and destroy' do 
          it { is_expected.to permit_actions([:edit, :update, :destroy]) }
        end
      end

      context 'user has groups_manage false and is a group leader' do 
        before {
          create(:user_group, :user => user, :group => group)
          create(:group_leader, :group => group, :user => user, :user_role => enterprise.user_roles.where(:role_type => "group").first)
          user.policy_group.groups_manage = false
          user.policy_group.save!
        }

        context 'allows access to index, create' do 
          let!(:group_message) {  nil }
          it { is_expected.to permit_actions([:index, :create]) }
        end

        context 'allows access to edit, update, and destroy' do 
          it { is_expected.to permit_actions([:edit, :update, :destroy]) }
        end
      end

      context "user has groups_manage false and is a group member" do
        before {
          create(:user_group, :user => user, :group => group)
          user.policy_group.groups_manage = false
          user.policy_group.save!
        }

        context 'allows access to index, create' do 
          let!(:group_message) {  nil }
          it { is_expected.to permit_actions([:index, :create]) }
        end

        context 'allows access to edit, update, and destroy' do 
          it { is_expected.to permit_actions([:edit, :update, :destroy]) }
        end
      end

      context "user has groups_manage false and is not an admin or group leader or member" do
        before {
          user.policy_group.groups_manage = false
          user.policy_group.save!
        }

        context 'allows access to index, create' do 
          let!(:group_message) {  nil }
          it { is_expected.to forbid_actions([:index, :create]) }
        end

        context 'allows access to edit, update, and destroy' do 
          it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
        end
      end
    end

    context "when manage_all is true" do
      before {
        user.policy_group.manage_all = true
        user.policy_group.group_resources_index = false
        user.policy_group.group_resources_create = false
        user.policy_group.group_resources_manage = false
        user.policy_group.save!
      }

      it "ensure manage_all is true" do
        expect(user.policy_group.manage_all).to be(true)
      end

      context 'allows access to index, create' do 
        let!(:group_message) {  nil }
        it { is_expected.to permit_actions([:index, :create]) }
      end

      context 'allows access to edit, update, and destroy' do 
        it { is_expected.to permit_actions([:edit, :update, :destroy]) }
      end
    end    
  end

  describe 'for users with no access' do 
    let!(:user) { no_access }

    context 'allows access to index, create' do 
      let!(:group_message) {  nil }
      it { is_expected.to forbid_actions([:index, :create]) }
    end

    context 'allows access to edit, update, and destroy' do 
      it { is_expected.to forbid_actions([:edit, :update, :destroy]) }
    end
  end
end

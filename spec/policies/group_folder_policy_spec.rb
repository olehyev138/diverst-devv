require 'rails_helper'

RSpec.describe GroupFolderPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:folder) { create(:folder, enterprise: enterprise) }

  subject { GroupFolderPolicy.new(user.reload, [group]) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.groups_manage = false
    no_access.policy_group.group_resources_index = false
    no_access.policy_group.group_resources_create = false
    no_access.policy_group.group_resources_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when groups_manage and group_resources_manage are true' do
        before { user.policy_group.update groups_manage: true, group_resources_manage: true }
        it { is_expected.to permit_actions([:index, :show, :new, :create, :edit, :update, :destroy]) }
      end

      context 'user has group leader permission for group_resources_manage' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update group_resources_manage: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:index, :show, :new, :create, :edit, :update, :destroy]) }
      end

      context 'user is group member and group_resources_manage is true' do
        before do
          create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true)
          user.policy_group.update group_resources_manage: true
        end

        it { is_expected.to permit_actions([:index, :show, :new, :create, :edit, :update, :destroy]) }
      end

      context 'when groups_manage and group_resources_create are true' do
        before { user.policy_group.update groups_manage: true, group_resources_create: true }
        it { is_expected.to permit_actions([:index, :show, :new, :create]) }
      end

      context 'user has group leader permission for group_resources_create' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update group_resources_create: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:index, :show, :new, :create]) }
      end

      context 'user is group member and group_resources_create is true' do
        before do
          create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true)
          user.policy_group.update group_resources_create: true
        end

        it { is_expected.to permit_actions([:index, :show, :new, :create]) }
      end

      context 'user is group member and group_resources_manage is true' do
        before do
          create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true)
          user.policy_group.update group_resources_manage: true
        end

        it { is_expected.to permit_actions([:index, :show, :new, :create, :edit, :update, :destroy]) }
      end

      context 'when groups_manage and group_resources_index are true' do
        before { user.policy_group.update groups_manage: true, group_resources_index: true }
        it { is_expected.to permit_actions([:index, :show]) }
      end

      context 'user has group leader permission for group_resources_index' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update group_resources_index: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:index, :show]) }
      end

      context 'user is group member and group_resources_index is true' do
        before do
          create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true)
          user.policy_group.update group_resources_index: true
        end

        it { is_expected.to permit_actions([:index, :show]) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }
      it { is_expected.to permit_actions([:index, :show, :new, :create, :edit, :update, :destroy]) }
    end
  end

  context 'for users with no access' do
    it { is_expected.to forbid_actions([:index, :show, :new, :create, :edit, :update, :destroy]) }
  end
end

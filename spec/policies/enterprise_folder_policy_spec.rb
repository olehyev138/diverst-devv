require 'rails_helper'

RSpec.describe EnterpriseFolderPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:folder) { create(:folder, enterprise: enterprise) }

  subject { EnterpriseFolderPolicy.new(user.reload, folder) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.enterprise_resources_index = false
    no_access.policy_group.enterprise_resources_create = false
    no_access.policy_group.enterprise_resources_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when enterprise_resources_index is true' do
        before { user.policy_group.update enterprise_resources_index: true }
        it { is_expected.to permit_actions([:index, :show]) }
      end

      context 'user has basic group leader permission for enterprise_resources_index' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update enterprise_resources_index: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:index, :show]) }
      end

      context 'when enterprise_resources_create is true' do
        before { user.policy_group.update enterprise_resources_create: true }
        it { is_expected.to permit_actions([:index, :show, :new, :create]) }
      end

      context 'user has basic group leader permission for enterprise_resources_create' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update enterprise_resources_create: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:index, :show, :new, :create]) }
      end

      context 'when enterprise_resources_manage is true' do
        before { user.policy_group.update enterprise_resources_manage: true }
        it { is_expected.to permit_actions([:index, :show, :new, :update, :destroy]) }
      end

      context 'user has basic group leader permission for enterprise_resources_manage' do
        before do
          user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update enterprise_resources_manage: true
          group = create(:group, enterprise: enterprise)
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:index, :show, :new, :update, :destroy]) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }
      it { is_expected.to permit_actions([:index, :show, :new, :update, :destroy]) }
    end
  end

  describe 'for users with no access' do
    it { is_expected.to forbid_actions([:index, :show, :new, :update, :destroy]) }
  end

  context '#basic_group_leader_permission?' do
    before do
      user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
      user_role.policy_group_template.update enterprise_resources_create: true
      group = create(:group, enterprise: enterprise)
      create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                            user_role_id: user_role.id)
    end

    it 'returns true' do
      expect(subject.basic_group_leader_permission?('enterprise_resources_create')).to be(true)
    end
  end
end

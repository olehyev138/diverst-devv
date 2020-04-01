require 'rails_helper'

RSpec.describe GroupBasePolicy, type: :policy do
  let(:no_access) { create(:user) }
  let(:user) { no_access }
  let(:group) { create(:group, owner: user, enterprise_id: user.enterprise_id) }

  subject { described_class.new(user.reload, [group, group]) }

  before do
    no_access.policy_group.manage_all = false
    no_access.policy_group.groups_index = false
    no_access.policy_group.groups_create = false
    no_access.policy_group.groups_manage = false
    no_access.policy_group.groups_budgets_index = false
    no_access.policy_group.groups_members_index = false
    no_access.policy_group.groups_budgets_request = false
    no_access.policy_group.budget_approval = false
    no_access.policy_group.global_calendar = false
    no_access.policy_group.save!

    class GroupBasePolicy
      def base_manage_permission
        'groups_manage'
      end

      def base_create_permission
        'budget_approval'
      end

      def base_index_permission
        'groups_members_index'
      end
    end
  end


  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when groups_manage is true' do
        before { user.policy_group.update groups_manage: true }

        it { is_expected.to permit_actions([:index, :show, :new, :create, :edit, :update, :destroy]) }
      end

      context 'user has leader group permissions and groups_manage is true' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update groups_manage: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:index, :show, :new, :create, :edit, :update, :destroy]) }
      end

      context 'when user is group member and groups_manage is true' do
        before do
          create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true)
          user.policy_group.update groups_manage: true
        end

        it { is_expected.to permit_actions([:index, :show, :new, :create, :edit, :update, :destroy]) }
      end

      context 'when groups_manage and groups_create are true' do
        before { user.policy_group.update groups_manage: true, groups_create: true }

        it { is_expected.to permit_actions([:index, :show, :new, :create, :edit, :update, :destroy]) }
      end

      context 'when user has group leader permissions and budget_approval is true' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update budget_approval: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:index, :show, :new, :create]) }
      end

      context 'when user is group member and budget_approval is true' do
        before do
          create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true)
          user.policy_group.update budget_approval: true
        end

        it { is_expected.to permit_actions([:index, :show, :new, :create]) }
      end
    end

    context 'when groups_manage and groups_members_index are true' do
      before { user.policy_group.update groups_manage: true, groups_members_index: true }

      it { is_expected.to permit_actions([:index, :show, :new, :create, :edit, :update, :destroy]) }
    end

    context 'when user has group leader permissions and groups_members_index is true' do
      before do
        user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
        user_role.policy_group_template.update groups_members_index: true
        create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                              user_role_id: user_role.id)
      end

      it { is_expected.to permit_actions([:index, :show]) }
    end

    context 'when user is group member and groups_members_index is true' do
      before do
        create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true)
        user.policy_group.update groups_members_index: true
      end

      it { is_expected.to permit_actions([:index, :show]) }
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      context 'base_index_permission, base_create_permission and base_manage_permission all return false' do
        it { is_expected.to permit_actions([:index, :show, :new, :create, :edit, :update, :destroy]) }
      end
    end
  end


  describe 'for users with no_access' do
    it { is_expected.to forbid_actions([:index, :show, :new, :create, :edit, :update, :destroy]) }
  end

  describe 'custom policies' do
    describe '#is_active_member?' do
      before { create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true) }

      it 'returns true' do
        expect(subject.is_active_member?).to be(true)
      end
    end

    describe '#is_a_manager?' do
      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.is_a_manager?('silly permissions')).to be(true)
        end
      end

      context 'has basic group leader permissions' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update groups_manage: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it 'returns true' do
          expect(subject.is_a_manager?('groups_manage')).to eq true
        end
      end
    end

    describe '#is_admin_manager?' do
      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.is_admin_manager?('silly permissions')).to be(true)
        end
      end

      context 'when groups_manage is true' do
        before { user.policy_group.update groups_manage: true }

        it 'returns true' do
          expect(subject.is_admin_manager?('groups_manage')).to be(true)
        end
      end
    end

    describe '#is_a_member?' do
      before { create(:user_group, user_id: user.id, group_id: group.id, accepted_member: false) }

      it 'returns true' do
        expect(subject.is_a_member?).to eq true
      end
    end

    describe '#is_a_pending_member?' do
      before { create(:user_group, user_id: user.id, group_id: group.id, accepted_member: false) }

      it 'returns true' do
        expect(subject.is_a_pending_member?).to eq true
      end
    end

    describe '#is_a_leader?' do
      before do
        user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
        user_role.policy_group_template.update groups_manage: true, group_settings_manage: true
        create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader', user_role_id: user_role.id)
      end

      it 'returns true' do
        expect(subject.is_a_leader?).to eq true
      end
    end

    describe '#has_group_leader_permissions?' do
      context 'when user is not a group leader' do
        before { user.policy_group.update groups_insights_manage: true }

        it 'returns false' do
          expect(subject.has_group_leader_permissions?('groups_insights_manage')).to eq false
        end
      end

      context 'when user is group leader' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update groups_layouts_manage: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it 'returns true' do
          expect(subject.has_group_leader_permissions?('groups_layouts_manage')).to eq true
        end
      end
    end

    describe '#basic_group_leader_permission?' do
      before do
        user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
        user_role.policy_group_template.update groups_manage: true
        create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                              user_role_id: user_role.id)
      end

      it 'returns true' do
        expect(subject.basic_group_leader_permission?('groups_manage')).to eq true
      end

      context 'group leader permissions are group specific' do
        let!(:another_group) { create(:group, enterprise: user.enterprise) }
        let!(:policy) { described_class.new(user, [another_group, another_group]) }

        it 'returns false' do
          expect(policy.has_group_leader_permissions?('groups_manage')).to eq false
        end
      end
    end

    describe '#view_group_resource' do
      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.view_group_resource('silly permissions')).to be(true)
        end
      end

      context 'when groups_manage is true' do
        before { user.policy_group.update groups_manage: true, groups_create: true }

        it 'returns true' do
          expect(subject.view_group_resource('groups_create')).to be(true)
        end
      end

      context 'when user is a leader and groups_create is true' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update budget_approval: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it 'returns true' do
          expect(subject.view_group_resource('budget_approval')).to be(true)
        end
      end

      context 'user is group member and budget_approval is true' do
        before do
          create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true)
          user.policy_group.update budget_approval: true
        end

        it 'returns true' do
          expect(subject.view_group_resource('budget_approval')).to be(true)
        end
      end

      context 'when user has no permissions' do
        it 'returns false' do
          expect(subject.view_group_resource('groups_manage')).to be(false)
        end
      end
    end

    describe '#manage_group_resource' do
      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.manage_group_resource('silly permissions')).to be(true)
        end
      end

      context 'when groups_manage is true' do
        before { user.policy_group.update groups_manage: true, groups_create: true }

        it 'returns true' do
          expect(subject.manage_group_resource('groups_create')).to be(true)
        end
      end

      context 'when user is a leader and groups_create is true' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update budget_approval: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it 'returns true' do
          expect(subject.manage_group_resource('budget_approval')).to be(true)
        end
      end

      context 'user is group member and budget_approval is true' do
        before do
          create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true)
          user.policy_group.update budget_approval: true
        end

        it 'returns true' do
          expect(subject.manage_group_resource('budget_approval')).to be(true)
        end
      end

      context 'when user has no permissions' do
        it 'returns false' do
          expect(subject.manage_group_resource('groups_manage')).to be(false)
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe GroupPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:group) { create(:group, owner: user, enterprise_id: enterprise.id) }
  let(:policy_scope) { GroupPolicy::Scope.new(user, Group).resolve }

  subject { described_class.new(user, group) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.groups_index = false
    no_access.policy_group.groups_create = false
    no_access.policy_group.groups_manage = false
    no_access.policy_group.groups_budgets_index = false
    no_access.policy_group.groups_budgets_manage = false
    no_access.policy_group.groups_members_index = false
    no_access.policy_group.groups_budgets_request = false
    no_access.policy_group.budget_approval = false
    no_access.policy_group.groups_manage = false
    no_access.policy_group.global_calendar = false
    no_access.policy_group.groups_layouts_manage = false
    no_access.policy_group.group_settings_manage = false
    no_access.policy_group.save!
  }

  permissions '.scope' do
    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      it 'shows only groups belonging to enterprise' do
        expect(policy_scope).to eq [group]
      end
    end
  end

  describe 'for users with access' do
    let!(:user) { no_access }

    context 'when manage_all is false' do
      context 'when groups_manage, groups_create are false but groups_index is true' do
        before { user.policy_group.update groups_index: true }

        it { is_expected.to permit_actions([:index, :show, :sort]) }
      end

      context 'groups_manage is true, groups_create and groups_index are false' do
        before { user.policy_group.update groups_manage: true }

        it { is_expected.to permit_actions([:index, :show, :sort, :new, :create, :update_all_sub_groups, :view_all,
                                            :add_category, :update_with_new_category, :update, :destroy])
        }
      end

      context 'groups_create is true, groups_manage and groups_index are false' do
        before { user.policy_group.update groups_create: true }

        it { is_expected.to permit_actions([:index, :show, :sort, :new, :create, :update_all_sub_groups, :view_all,
                                            :add_category, :update_with_new_category, :update, :destroy])
        }
      end

      context 'when ONLY global_calendar is true, and current user IS NOT owner' do
        before do
          group.owner = create(:user)
          user.policy_group.update global_calendar: true
        end

        it { is_expected.to permit_action(:calendar) }
      end

      context 'ONLY groups_manage is true, and current user is a member but IS NOT owner' do
        before do
          create(:user_group, user_id: user.id, group_id: group.id)
          user.policy_group.update groups_layouts_manage: true
        end

        it { is_expected.to permit_action(:layouts) }
      end

      context 'is group leader with group layout permissions and current user IS owner' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update groups_layouts_manage: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:update, :destroy, :layouts]) }
      end

      context 'is group leader with group layout permissions and current user IS NOT owner' do
        before do
          group.owner = create(:user)
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update groups_layouts_manage: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_action(:layouts) }
      end

      context 'ONLY groups_manage is true, and current user is a member but IS NOT owner' do
        before do
          create(:user_group, user_id: user.id, group_id: group.id)
          user.policy_group.update group_settings_manage: true
        end

        it { is_expected.to permit_action(:settings) }
      end

      context 'is group leader with group settings permissions and current user IS owner' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update group_settings_manage: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:update, :destroy, :settings]) }
      end

      context 'is group leader with group settings permissions and current user IS NOT owner' do
        before do
          group.owner = create(:user)
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update group_settings_manage: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_action(:settings) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      context 'when groups_manage, groups_create groups_index are false' do
        it { is_expected.to permit_actions([:index, :new, :show, :create, :sort, :view_all, :add_category, :update_with_new_category,
                                            :update, :destroy, :calendar, :layouts, :settings])
        }
      end
    end
  end

  describe 'for users with no access' do
    before { group.owner = create(:user) }
    let!(:user) { no_access }
    it { is_expected.to forbid_actions([:index, :show, :sort, :new, :create, :update_all_sub_groups, :view_all,
                                        :add_category, :update_with_new_category, :update, :destroy, :settings, :layouts, :calendar])
    }
  end

  describe 'custom policies' do
    let!(:user) { no_access }

    describe '#insights?' do
      context 'when ONLY manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.insights?).to eq true
        end
      end

      context 'when groups_manage and groups_insights_manage are true' do
        before { user.policy_group.update groups_manage: true, groups_insights_manage: true }

        it 'returns true' do
          expect(subject.insights?).to eq true
        end
      end

      context 'user is group leader and groups_insights_manage is true' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update groups_insights_manage: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it 'returns true' do
          expect(subject.insights?).to eq true
        end
      end

      context 'user is member and groups_insights_manage is true' do
        before do
          create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true)
          user.policy_group.update groups_insights_manage: true
        end

        it 'returns true' do
          expect(subject.insights?).to eq true
        end
      end
    end

    describe '#parent_group_permissions?' do
      context 'when group has no parent' do
        it 'returns false' do
          expect(subject.parent_group_permissions?).to eq false
        end
      end

      context 'when group has parent' do
        before { group.parent = create(:group, enterprise: user.enterprise) }

        it 'returns true' do
          expect(subject.parent_group_permissions?).to eq ::GroupPolicy.new(user.reload, group.parent).manage?
        end
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

    describe '#manage?' do
      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.manage?).to eq true
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
          expect(subject.manage?).to eq true
        end
      end
    end

    describe '#manage_all_group_budgets?' do
      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.manage_all_group_budgets?).to eq true
        end
      end

      context 'when group manage and groups_budgets_manage are true' do
        before { user.policy_group.update groups_manage: true, groups_budgets_manage: true }

        it 'returns true' do
          expect(subject.manage_all_group_budgets?).to eq true
        end
      end

      context 'has basic group leader permissions' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update groups_manage: true, groups_budgets_manage: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it 'returns true' do
          expect(subject.manage_all_group_budgets?).to eq true
        end
      end
    end

    describe '#manage_all_groups?' do
      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.manage_all_groups?).to eq true
        end
      end

      context 'when group manage and group_settings_manage are true' do
        before { user.policy_group.update groups_manage: true, group_settings_manage: true }

        it 'returns true' do
          expect(subject.manage_all_groups?).to eq true
        end
      end

      context 'has basic group leader permissions' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update groups_manage: true, group_settings_manage: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it 'returns true' do
          expect(subject.manage_all_groups?).to eq true
        end
      end
    end

    describe '#is_a_pending_member?' do
      before { create(:user_group, user_id: user.id, group_id: group.id, accepted_member: false) }

      it 'returns true' do
        expect(subject.is_a_pending_member?).to eq true
      end
    end

    describe '#is_an_accepted_member?' do
      before { create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true) }

      it 'returns true' do
        expect(subject.is_an_accepted_member?).to eq true
      end
    end

    describe '#is_a_member?' do
      before { create(:user_group, user_id: user.id, group_id: group.id, accepted_member: false) }

      it 'returns true' do
        expect(subject.is_a_member?).to eq true
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
  end
end

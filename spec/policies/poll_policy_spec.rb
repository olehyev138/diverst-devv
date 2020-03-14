require 'rails_helper'

RSpec.describe PollPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:enterprise_2) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:poll) { create(:poll, status: 0, enterprise: enterprise, groups: [], owner_id: user.id) }
  let(:polls) { create_list(:poll, 10, status: 0, enterprise: enterprise_2, groups: []) }
  let(:policy_scope) { PollPolicy::Scope.new(user, Poll).resolve }

  subject { PollPolicy.new(user.reload, poll) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.polls_index = false
    no_access.policy_group.polls_create = false
    no_access.policy_group.polls_manage = false
    no_access.policy_group.save!
  }

  permissions '.scope' do
    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      it 'shows only segments belonging to enterprise' do
        expect(policy_scope).to eq [poll]
      end
    end
  end

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when current user IS NOT owner' do
        before { poll.owner = create(:user) }

        context 'when polls_index is true and current user IS NOT owner' do
          before { user.policy_group.update polls_index: true }
          it { is_expected.to permit_action(:index) }
        end

        context 'user has basic group leader permission for polls_index, current user IS NOT owner' do
          before do
            user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update polls_index: true
            group = create(:group, enterprise: enterprise)
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it { is_expected.to permit_action(:index) }
        end

        context 'user has basic group leader permission for polls_create, current user IS NOT owner' do
          before do
            user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update polls_create: true
            group = create(:group, enterprise: enterprise)
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it { is_expected.to permit_actions([:index, :create]) }
        end

        context 'when polls_create is true' do
          before { user.policy_group.update polls_create: true }
          it { is_expected.to permit_actions([:index, :create]) }
        end

        context 'when polls_manage is true' do
          before { user.policy_group.update polls_manage: true }
          it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
        end

        context 'user has basic group leader permission for polls_manage, current user IS NOT owner' do
          before do
            user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update polls_manage: true
            group = create(:group, enterprise: enterprise)
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
        end
      end

      context 'when current user IS owner' do
        it { is_expected.to permit_actions([:update, :destroy]) }
      end
    end

    context 'when manage_all is true' do
      before do
        poll.owner = create(:user)
        user.policy_group.update manage_all: true
      end
      it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
    end
  end

  describe 'for users with no access' do
    context 'with no polls permissions, current user IS NOT owner' do
      before { poll.owner = create(:user) }
      it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
    end

    context 'when scope_module_enabled is false' do
      before { enterprise.update scope_module_enabled: false }
      it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
    end
  end

  describe '#manage?' do
    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      it 'returns true' do
        expect(subject.manage?).to be(true)
      end
    end

    context 'user has basic group leader permission for polls_manage' do
      before do
        user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
        user_role.policy_group_template.update polls_manage: true
        group = create(:group, enterprise: enterprise)
        create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                              user_role_id: user_role.id)
      end

      it 'returns true' do
        expect(subject.manage?).to be(true)
      end
    end

    context 'when polls_manage is true' do
      before { user.policy_group.update polls_manage: true }

      it 'returns true' do
        expect(subject.manage?).to be(true)
      end
    end
  end
end

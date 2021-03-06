require 'rails_helper'

RSpec.describe GroupBudgetPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:no_access) { create(:user) }
  let(:budget) { create(:budget, group_id: group.id) }
  let!(:user) { no_access }

  subject { described_class.new(user, [group, budget]) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.groups_manage = false
    no_access.policy_group.groups_budgets_index = false
    no_access.policy_group.groups_budgets_request = false
    no_access.policy_group.groups_budgets_manage = false
    no_access.policy_group.budget_approval = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when budget is approved' do
      before { budget.is_approved = true }

      context 'when admin?' do
        before { allow(subject).to receive(:admin?).and_return(true) }

        it { is_expected.to permit_action(:destroy) }
      end
    end

    context 'when budget is not approved' do
      context 'when current user is requester' do
        let(:budget1) { create(:budget, group_id: group.id, requester: user) }
        subject { described_class.new(user, [group, budget1]) }

        before { allow(subject).to receive(:admin?).and_return(false) }

        it { is_expected.to permit_action(:destroy) }
      end
    end

    context 'when manage_all is false' do
      context 'when groups_manage and groups_budgets_manage are true' do
        before { user.policy_group.update groups_manage: true, groups_budgets_manage: true }

        it { is_expected.to permit_actions([:approve, :decline]) }
      end

      context 'user has group leader permissions and groups_budgets_manage is true' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update groups_budgets_manage: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:approve, :decline]) }
      end

      context 'user is group member and groups_budgets_manage is true' do
        before do
          create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true)
          user.policy_group.update groups_budgets_manage: true
        end

        it { is_expected.to permit_actions([:approve, :decline]) }
      end

      context 'user has basic group leader permissions and budget_approval is true' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update budget_approval: true
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it { is_expected.to permit_actions([:approve, :decline]) }
      end

      context 'when budget_approval is true' do
        before { user.policy_group.update budget_approval: true }

        it { is_expected.to permit_actions([:approve, :decline]) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      context 'when budget_approval, groups_budgets_manage, groups_budgets_request, groups_budgets_index and groups_manage are false' do
        before { user.policy_group.update budget_approval: false, groups_budgets_index: false, groups_budgets_manage: false,
                                          groups_budgets_request: false, groups_manage: false
        }

        it { is_expected.to permit_actions([:approve, :decline]) }
      end
    end
  end

  describe 'for users with no access' do
    it { is_expected.to forbid_actions([:approve, :decline]) }

    context 'when not admin?' do
      before { allow(subject).to receive(:admin?).and_return(false) }

      it { is_expected.to forbid_action(:destroy) }
    end

    context 'when budget is not approved' do
      context 'when current user is not requester' do
        let(:budget1) { create(:budget, group_id: group.id, requester: create(:user)) }
        subject { described_class.new(user, [group, budget1]) }

        before { allow(subject).to receive(:admin?).and_return(false) }

        it { is_expected.to forbid_action(:destroy) }
      end
    end
  end

  describe '#manage_all_budgets' do
    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      it 'returns true' do
        expect(subject.manage_all_budgets?).to eq true
      end
    end

    context 'when groups_budgets_manage and groups_manage are true' do
      before { user.policy_group.update groups_budgets_manage: true, groups_manage: true }

      it 'returns true' do
        expect(subject.manage_all_budgets?).to eq true
      end
    end
  end
end

require 'rails_helper'

RSpec.describe InitiativeExpensePolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }

  let(:group) { create :group, enterprise: enterprise, annual_budget: 10000 }
  let(:annual_budget) { create :annual_budget, group_id: group.id, amount: group.annual_budget }
  let(:outcome) { create :outcome, group_id: group.id }
  let(:pillar) { create :pillar, outcome_id: outcome.id }
  let(:budget) { create(:approved_budget, annual_budget: annual_budget) }
  let(:initiative) { create :initiative, pillar: pillar, owner_group: group, owner: user, budget_item: budget.budget_items.first }
  let(:initiative_expense) { create(:initiative_expense, initiative: initiative, owner: user) }
  let(:policy_scope) { InitiativeExpensePolicy::Scope.new(user, InitiativeExpense).resolve }

  subject { described_class.new(user, initiative_expense) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.initiatives_index = false
    no_access.policy_group.initiatives_manage = false
    no_access.policy_group.save!
  }


  permissions '.scope' do
    context 'when manage_all is true' do
      before do
        user.policy_group.update manage_all: true
        initiative_expense
      end

      it 'shows only initiative_expenses with outcomes belonging to users group' do
        expect(policy_scope).to eq [initiative_expense]
      end
    end
  end

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when current user IS NOT owner' do
        before { initiative_expense.owner = create(:user) }

        context 'when initiatives_index is true' do
          before { user.policy_group.update initiatives_index: true }
          it { is_expected.to permit_action(:index) }
        end

        context 'user has basic group leader permission for initiatives_index' do
          before do
            user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update initiatives_index: true
            group = create(:group, enterprise: enterprise)
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it { is_expected.to permit_action(:index) }
        end

        context 'when initiatives_manage is true' do
          before { user.policy_group.update initiatives_manage: true }
          it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
        end

        context 'user has basic group leader permission for initiatives_manage' do
          before do
            user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update initiatives_manage: true
            group = create(:group, enterprise: enterprise)
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
        end
      end

      context 'when current user IS owner' do
        it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      context 'when initiatives_index and initiatives_manage are false, current user IS NOT owner' do
        before do
          initiative_expense.owner = create(:user)
          user.policy_group.update initiatives_index: false, initiatives_manage: false
        end

        it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
      end
    end
  end

  describe 'for users with no access' do
    before { initiative_expense.owner = create(:user) }
    it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
  end
end

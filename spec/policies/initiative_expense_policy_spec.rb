require 'rails_helper'

RSpec.describe InitiativeExpensePolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, enterprise: enterprise) }
  let(:no_access) { create(:user) }

  let(:group) { create :group, enterprise: user.enterprise }
  let(:outcome) {create :outcome, group_id: group.id}
  let(:pillar) { create :pillar, outcome_id: outcome.id}
  let(:initiative) { create :initiative, pillar: pillar, owner_group: group, owner: user}
  let(:initiative_expense){ create(:initiative_expense, initiative: initiative, owner: user) }
  let(:policy_scope) { InitiativeExpensePolicy::Scope.new(user, InitiativeExpense).resolve }

  subject { described_class }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.initiatives_index = false
    no_access.policy_group.initiatives_manage = false
    no_access.policy_group.save!
  }

  permissions :index?, :create?, :update?, :destroy? do
    it 'allows access to a manager' do
      expect(subject).to permit(user, initiative_expense)
    end

    it 'denies access to a user without correct permissions' do
      expect(subject).to_not permit(no_access, initiative_expense)
    end
  end

  permissions :index?, :update?, :destroy? do
    it 'allows access to a normal user' do
      user.policy_group.initiatives_manage = false
      expect(subject).to permit(user, initiative_expense)
    end
  end

  permissions ".scope" do
    before { initiative_expense }

    it "shows only initiative_expenses with outcomes belonging to users group" do
      expect(policy_scope).to eq [initiative_expense]
    end
  end
end

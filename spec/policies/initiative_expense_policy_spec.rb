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

  subject { described_class.new(user, initiative_expense) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.initiatives_index = false
    no_access.policy_group.initiatives_manage = false
    no_access.policy_group.save!
  }


  permissions ".scope" do
    before { initiative_expense }

    it "shows only initiative_expenses with outcomes belonging to users group" do
      expect(policy_scope).to eq [initiative_expense]
    end
  end
  
  describe 'for users with access' do
    context 'when manage_all is false' do 
      context 'when initiatives_manage is false and current user IS NOT owner' do 
        before do 
          initiative_expense.owner = create(:user)
          user.policy_group.update initiatives_manage: false, initiatives_index: true
        end

        it { is_expected.to permit_action(:index) }
      end

      context 'when initiative_manage is true and initiatives_index is false and current user IS NOT owner' do 
        before do 
          initiative_expense.owner = create(:user)
          user.policy_group.update initiatives_manage: true, initiatives_index: false
        end

        it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
      end
      
      context 'when initiatives_index and initiatives_manage are false, current user IS owner' do 
        before { user.policy_group.update initiatives_manage: false, initiatives_index: false }
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
    let!(:user) { no_access }
    it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
  end
end

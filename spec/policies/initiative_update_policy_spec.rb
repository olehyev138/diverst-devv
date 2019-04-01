require 'rails_helper'

RSpec.describe InitiativeUpdatePolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, enterprise: enterprise) }
  let(:no_access) { create(:user) }

  let(:group) { create :group, enterprise: user.enterprise }
  let(:outcome) {create :outcome, group_id: group.id}
  let(:pillar) { create :pillar, outcome_id: outcome.id}
  let(:initiative) { create :initiative, pillar: pillar, owner_group: group, owner: user}
  let(:initiative_update){ create(:initiative_update, initiative: initiative, owner: user) }
  let(:policy_scope) { InitiativeUpdatePolicy::Scope.new(user, InitiativeUpdate).resolve }

  subject { described_class.new(user, initiative_update) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.save!

    no_access.policy_group.manage_all = false
    no_access.policy_group.initiatives_index = false
    no_access.policy_group.initiatives_manage = false
    no_access.policy_group.save!
  }

  permissions ".scope" do
    before { initiative_update }

    it "shows only initiative_updates with outcomes belonging to users group" do
      expect(policy_scope).to eq [initiative_update]
    end
  end

  describe 'for users with access' do 
    context 'when manage_all is false' do 
      context 'when ONLY initiatives_index is true and current user IS NOT owner' do 
        before do 
          initiative_update.owner = create(:user)
          user.policy_group.update initiatives_index: true, initiatives_manage: false
        end

        it { is_expected.to permit_action(:index) }
      end 

      context 'when ONLY initiatives_manage is true and current user IS NOT owner' do 
        before do
          initiative_update.owner = create(:user)
          user.policy_group.update initiatives_manage: true, initiatives_index: false
        end

        it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
      end

      context 'when initiatives_index and initiatives_manage are false, but current user IS owner' do 
        before { user.policy_group.update initiatives_manage: false, initiatives_index: false }
        it { is_expected.to permit_actions([:update, :destroy]) }
      end
    end

    context 'when manage_all is true' do 
      before { user.policy_group.update manage_all: true }

      context 'initiatives_index is true and initiatives_manage is false, but current user IS NOT owner' do 
        before do
          initiative_update.owner = create(:user)
          user.policy_group.update initiatives_index: true, initiatives_manage: false
        end

        it { is_expected.to permit_action(:index) }
      end

      context 'when initiatives_index and initiatives_manage are false, but current user IS owner' do 
        before { user.policy_group.update initiatives_index: false, initiatives_manage: false }
        it { is_expected.to permit_actions([:update, :destroy]) }
      end
    end
  end

  describe 'for users with no access' do 
    before { initiative_update.owner = create(:user) }
    let!(:user) { no_access }
  end
end

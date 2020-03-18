require 'rails_helper'

RSpec.describe InitiativeUpdatePolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user) }
  let(:user) { no_access }

  let(:group) { create :group, enterprise: user.enterprise }
  let(:outcome) { create :outcome, group_id: group.id }
  let(:pillar) { create :pillar, outcome_id: outcome.id }
  let(:initiative) { create :initiative, pillar: pillar, owner_group: group, owner: user }
  let(:initiative_update) { create(:initiative_update, initiative: initiative, owner: user) }
  let(:policy_scope) { InitiativeUpdatePolicy::Scope.new(user, InitiativeUpdate).resolve }

  subject { described_class.new(user, initiative_update) }

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
        initiative_update
      end

      it 'shows only initiative_updates with outcomes belonging to users group' do
        expect(policy_scope).to eq [initiative_update]
      end
    end
  end

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'current user IS NOT owner' do
        before { initiative_update.owner = create(:user) }

        context 'when initiatives_index is true' do
          before { user.policy_group.update initiatives_index: true }
          it { is_expected.to permit_action(:index) }
        end

        context 'when initiatives_manage is true' do
          before { user.policy_group.update initiatives_manage: true }
          it { is_expected.to permit_actions([:index, :create, :update, :destroy]) }
        end
      end

      context 'when current user IS owner' do
        it { is_expected.to permit_actions([:update, :destroy]) }
      end
    end
  end

  describe 'for users with no access' do
    context 'when manage_all is true' do
      context 'when current IS NOT owner' do
        before do
          initiative_update.owner = create(:user)
          user.policy_group.update manage_all: true
        end

        it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
      end
    end

    context 'when manage_all is false' do
      context 'when current IS NOT owner' do
        before { initiative_update.owner = create(:user) }
        it { is_expected.to forbid_actions([:index, :create, :update, :destroy]) }
      end
    end
  end
end

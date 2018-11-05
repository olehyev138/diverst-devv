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
    it 'allows access to a user with correct permissions' do
      expect(subject).to permit(user, initiative_update)
    end

    it 'denies access to a user without correct permissions' do
      expect(subject).to_not permit(no_access, initiative_update)
    end
  end

  permissions :update?, :destroy? do
    it 'allows normal users to update & destroy' do
      user.policy_group.initiatives_manage = false

      expect(subject).to permit(user, initiative_update)
    end
  end

  permissions ".scope" do
    before { initiative_update }

    it "shows only initiative_updates with outcomes belonging to users group" do
      expect(policy_scope).to eq [initiative_update]
    end
  end

end

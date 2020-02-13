require 'rails_helper'

RSpec.describe RewardPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:reward) { create(:reward) }

  subject { RewardPolicy.new(user, reward) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.diversity_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when diversity_manage is true' do
        before { user.policy_group.update diversity_manage: true }
        it { is_expected.to permit_actions([:index, :new, :create, :update, :destroy]) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }
      it { is_expected.to permit_actions([:index, :new, :create, :update, :destroy]) }
    end
  end

  describe '#user_responsible?' do
    context 'returns true' do
      let!(:user1) { create(:user, enterprise: enterprise) }
      let!(:reward1) { create(:reward, responsible_id: user1.id, points: 10) }

      it 'returns true' do
        expect(RewardPolicy.new(reward1.responsible, reward1).user_responsible?).to eq(true)
      end
    end
  end

  describe 'for users with no access' do
    let(:user) { no_access }
    it { is_expected.to forbid_actions([:index, :new, :create, :update, :destroy]) }
  end
end

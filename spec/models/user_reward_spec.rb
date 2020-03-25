require 'rails_helper'

RSpec.describe UserReward do
  describe 'when validating' do
    let(:user_reward) { build_stubbed(:user_reward) }

    it { expect(user_reward).to validate_presence_of(:user) }
    it { expect(user_reward).to validate_presence_of(:reward) }
    it { expect(user_reward).to validate_presence_of(:points) }
    it { expect(user_reward).to validate_numericality_of(:points).only_integer }
    it { expect(user_reward).to belong_to(:user) }
    it { expect(user_reward).to belong_to(:reward) }
  end

  describe '#Enumerize' do
    let(:user_reward) { build(:user_reward) }

    it { expect(user_reward).to enumerize(:status).in(:pending, :redeemed, :forfeited) }
  end

  describe '#approve_reward_redemption' do
    let(:user_reward) { create(:user_reward, status: 0) }

    before { user_reward.approve_reward_redemption }

    it 'returns status as redeemed' do
      expect(user_reward.status).to eq(1)
      expect(user_reward.status.redeemed?).to eq(true)
    end
  end
end

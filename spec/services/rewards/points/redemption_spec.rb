require 'rails_helper'

RSpec.describe Rewards::Points::Redemption do
  describe '#redeem' do
    let(:user) { create(:user) }
    let(:reward) { create(:reward, points: 100) }
    let(:redemption) { Rewards::Points::Redemption.new(user, reward) }

    context 'when user have enough credits' do
      before(:each) do
        create(:user_reward_action, user: user, operation: 'add', points: 100)
      end

      it 'creates a user_reward' do
        expect { redemption.redeem }.to change(UserReward.where(user: user, reward: reward), :count).by(1)
      end

      it 'send an email to responsible of reward' do
        user_reward = UserReward.create(reward: reward, user: user, status: 0)
        allow(RewardMailerJob).to receive(:perform_later)
        redemption.redeem

        expect(RewardMailerJob).to have_received(:perform_later)
      end

      it 'returns true' do
        expect(redemption.redeem).to be_truthy
      end
    end

    context 'when user does not have enough credits' do
      it 'does not create user_reward' do
        expect { redemption.redeem }.to_not change(UserReward, :count)
      end

      it 'does not send any email' do
        expect(RewardMailer).to_not receive(:request_to_redeem_reward)

        redemption.redeem
      end

      it 'returns false' do
        expect(redemption.redeem).to be_falsy
      end
    end
  end
end

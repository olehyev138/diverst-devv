require 'rails_helper'

RSpec.describe Rewards::Points::Redemption do
  describe "#redeem" do
    let(:user){ create(:user) }
    let(:reward){ create(:reward, points: 100) }
    let(:redemption){ Rewards::Points::Redemption.new(user, reward) }

    context "when user have enough credits" do
      before(:each) do
        create(:user_reward_action, user: user, operation: "add", points: 100)
      end

      it "creates a user_reward" do
        expect{ redemption.redeem }.to change(UserReward.where(user: user, reward: reward), :count).by(1)
      end

      it "send an email to responsible of reward" do
        mailer = double("RewardMailer")
        expect(RewardMailer).to receive(:redeem_reward).with(reward.responsible, user, reward){ mailer }
        expect(mailer).to receive(:deliver_later)

        redemption.redeem
      end

      it "updates user credits" do
        redemption.redeem
        expect(user.credits).to eq 0
      end

      it "returns true" do
        expect(redemption.redeem).to be_truthy
      end
    end

    context "when user does not have enough credits" do
      it "does not create user_reward" do
        expect{ redemption.redeem }.to_not change(UserReward, :count)
      end

      it "does not send any email" do
        expect(RewardMailer).to_not receive(:redeem_reward)

        redemption.redeem
      end

      it "returns false" do
        expect(redemption.redeem).to be_falsy
      end
    end
  end
end

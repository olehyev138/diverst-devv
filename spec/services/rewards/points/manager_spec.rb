require 'rails_helper'

RSpec.describe Rewards::Points::Manager do
  describe "#add_points" do
    let(:user){ create(:user, points: 5, credits: 10) }
    let(:reward_action){ create(:reward_action, enterprise: user.enterprise, points: 40) }
    let(:initiative){ create(:initiative) }

    context "when action exists on enterprise" do
      let(:manager){ Rewards::Points::Manager.new(user, reward_action.key) }

      before :each do
        create(:user_reward_action, user: user, operation: "add", points: 50)
        create(:user_reward_action, user: user, operation: "add", points: 50, entity: initiative)
        create(:user_reward_action, user: user, operation: "add", points: 100, entity: initiative)
        create(:user_reward_action, user: user, operation: "del", points: 50, entity: initiative)
        create(:user_reward, user: user, points: 150)
      end

      it "register the points earned by user" do
        expect{ manager.add_points(initiative) }.to change(
          UserRewardAction.where(user: user, operation: UserRewardAction.operations[:add],
            entity: initiative, reward_action: reward_action, points: reward_action.points), :count
        ).by(1)
      end

      it "add the points of an action to points user already received" do
        manager.add_points(initiative)
        user.reload

        # 40 + 50 + 50 + 100 - 50 = 190
        expect(user.points).to eq 190
      end

      it "updates the credits of a user considering the amount of points user received and rewards he redeemed" do
        manager.add_points(initiative)
        user.reload

        # (40 + 50 + 50 + 100 - 50) - 150 = 40
        expect(user.credits).to eq 40
      end
    end

    context "when action does not exists on enterprise" do
      let(:manager){ Rewards::Points::Manager.new(user, "unknown") }

      it "does not gives the points of action to user" do
        expect{ manager.add_points(initiative) }
          .to_not change(UserRewardAction.where(user: user), :count)
      end

      it "does not changes the points" do
        manager.add_points(initiative)
        user.reload

        expect(user.points).to eq 5
      end

      it "does not changes the credits" do
        manager.add_points(initiative)
        user.reload

        expect(user.credits).to eq 10
      end
    end
  end

  describe "#remove_points" do
    let(:user){ create(:user, points: 5, credits: 10) }
    let(:reward_action){ create(:reward_action, enterprise: user.enterprise, points: 40) }
    let(:initiative){ create(:initiative) }

    context "when action exists on enterprise" do
      let(:manager){ Rewards::Points::Manager.new(user, reward_action.key) }

      before :each do
        now = Time.now

        create(:user_reward_action, user: user, operation: "add", points: 50, created_at: now + 1.second)
        create(:user_reward_action, user: user, reward_action: reward_action, operation: "add", points: 50, created_at: now + 2.seconds, entity: initiative)
        create(:user_reward_action, user: user, reward_action: reward_action, operation: "add", points: 100, created_at: now + 3.seconds, entity: initiative)
        create(:user_reward_action, user: user, operation: "del", points: 50, entity: initiative)
        create(:user_reward, user: user, points: 150)
      end

      it "register remove of points from the user" do
        expect{ manager.remove_points(initiative) }.to change(
          UserRewardAction.where(user: user, operation: UserRewardAction.operations[:del],
            entity: initiative, reward_action: reward_action), :count
        ).by(1)
      end

      it "removes the amount of points of the latest action of same entity from points user already received" do
        manager.remove_points(initiative)
        user.reload

        # (-100 + 50 + 50 + 100 - 50) = 50
        expect(user.points).to eq 50
      end

      it "updates the credits of a user considering the amount of points user received and rewards he redeemed" do
        manager.remove_points(initiative)
        user.reload

        # (-100 + 50 + 50 + 100 - 50) - 150 = -100
        expect(user.credits).to eq(-100)
      end
    end

    context "when action does not exists on enterprise" do
      let(:manager){ Rewards::Points::Manager.new(user, "unknown") }

      it "does not gives the points of action to user" do
        expect{ manager.remove_points(initiative) }
          .to_not change(UserRewardAction.where(user: user), :count)
      end

      it "does not changes the points" do
        manager.remove_points(initiative)
        user.reload

        expect(user.points).to eq 5
      end

      it "does not changes the credits" do
        manager.remove_points(initiative)
        user.reload

        expect(user.credits).to eq 10
      end
    end
  end
end

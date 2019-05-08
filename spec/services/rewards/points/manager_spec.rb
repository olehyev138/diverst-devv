require 'rails_helper'

RSpec.describe Rewards::Points::Manager do
  describe '#add_points' do
    let(:user) { create(:user, points: 5, credits: 10, total_weekly_points: 20) }
    let(:reward_action) { create(:reward_action, enterprise: user.enterprise, points: 40) }
    let(:group) { create(:group, total_weekly_points: 15) }
    let!(:user_group) { create(:user_group, user: user, group: group, total_weekly_points: 25) }
    let(:initiative) { create(:initiative, owner_group: group) }

    context 'when action exists on enterprise' do
      let(:manager) { Rewards::Points::Manager.new(user, reward_action.key) }

      before :each do
        create(:user_reward_action, user: user, operation: 'add', points: 50)
        create(:user_reward_action, user: user, operation: 'add', points: 50, initiative: initiative)
        create(:user_reward_action, user: user, operation: 'add', points: 100, initiative: initiative)
        create(:user_reward_action, user: user, operation: 'del', points: 50, initiative: initiative)
        create(:user_reward, user: user, points: 150)
      end

      it 'register the points earned by user' do
        expect { manager.add_points(initiative) }.to change(
          UserRewardAction.where(user: user, operation: UserRewardAction.operations[:add],
                                 initiative: initiative, reward_action: reward_action, points: reward_action.points), :count
        ).by(1)
      end

      it 'add the points of an action to points user already received' do
        manager.add_points(initiative)
        user.reload

        # 40 + 50 + 50 + 100 - 50 = 190
        expect(user.points).to eq 190
      end

      it 'updates the credits of a user considering the amount of points user received and rewards he redeemed' do
        manager.add_points(initiative)
        user.reload

        # (40 + 50 + 50 + 100 - 50) - 150 = 40
        expect(user.credits).to eq 40
      end

      it 'add reward_action points to total of points of a user in the current week' do
        manager.add_points(initiative)
        user.reload

        # 20 + 40 = 60
        expect(user.total_weekly_points).to eq 60
      end

      it 'add reward_action points to total of points of a group in the current week' do
        manager.add_points(initiative)
        group.reload

        # 15 + 40 = 60
        expect(group.total_weekly_points).to eq 55
      end

      it 'add reward_action points to total of points of a user_group in the current week' do
        manager.add_points(initiative)
        user_group.reload

        # 25 + 40 = 60
        expect(user_group.total_weekly_points).to eq 65
      end
    end

    context 'when action does not exists on enterprise' do
      let(:manager) { Rewards::Points::Manager.new(user, 'unknown') }

      it 'does not gives the points of action to user' do
        expect { manager.add_points(initiative) }
          .to_not change(UserRewardAction.where(user: user), :count)
      end

      it 'does not changes the points' do
        manager.add_points(initiative)
        user.reload

        expect(user.points).to eq 5
      end

      it 'does not changes the credits' do
        manager.add_points(initiative)
        user.reload

        expect(user.credits).to eq 10
      end
    end
  end

  describe '#remove_points' do
    let(:user) { create(:user, points: 5, credits: 10, total_weekly_points: 50) }
    let(:reward_action) { create(:reward_action, enterprise: user.enterprise, points: 40) }
    let(:group) { create(:group, total_weekly_points: 60) }
    let!(:user_group) { create(:user_group, user: user, group: group, total_weekly_points: 70) }
    let(:initiative) { create(:initiative, owner_group: group) }

    context 'when action exists on enterprise' do
      let(:manager) { Rewards::Points::Manager.new(user, reward_action.key) }

      before :each do
        now = Time.now

        create(:user_reward_action, user: user, operation: 'add', points: 50, created_at: now + 1.second)
        create(:user_reward_action, user: user, reward_action: reward_action, operation: 'add', points: 50, created_at: now + 2.seconds, initiative: initiative)
        create(:user_reward_action, user: user, reward_action: reward_action, operation: 'add', points: 100, created_at: now + 3.seconds, initiative: initiative)
        create(:user_reward_action, user: user, operation: 'del', points: 50, initiative: initiative)
        create(:user_reward, user: user, points: 150)
      end

      it 'register remove of points from the user' do
        expect { manager.remove_points(initiative) }.to change(
          UserRewardAction.where(user: user, operation: UserRewardAction.operations[:del],
                                 initiative: initiative, reward_action: reward_action), :count
        ).by(1)
      end

      context 'when user received points of this action' do
        it 'removes the amount of points of the latest action of same entity from points user already received' do
          manager.remove_points(initiative)
          user.reload

          # (-100 + 50 + 50 + 100 - 50) = 50
          expect(user.points).to eq 50
        end
      end

      context 'when user did not receive points of this action' do
        it 'does not remove points from user' do
          manager.remove_points(create(:initiative))
          user.reload

          # (0 + 50 + 50 + 100 - 50) = 150
          expect(user.points).to eq 150
        end
      end

      it 'updates the credits of a user considering the amount of points user received and rewards he redeemed' do
        manager.remove_points(initiative)
        user.reload

        # (-100 + 50 + 50 + 100 - 50) - 150 = -100
        expect(user.credits).to eq(-100)
      end

      it 'remove reward_action points from total of points of a user in the current week' do
        manager.remove_points(initiative)
        user.reload

        # 50 - 40 = 10
        expect(user.total_weekly_points).to eq 10
      end

      it 'remove reward_action points from total of points of a group in the current week' do
        manager.remove_points(initiative)
        group.reload

        # 60 - 40 = 20
        expect(group.total_weekly_points).to eq 20
      end

      it 'remove reward_action points from total of points of a user_group in the current week' do
        manager.remove_points(initiative)
        user_group.reload

        # 70 - 40 = 30
        expect(user_group.total_weekly_points).to eq 30
      end
    end

    context 'when action does not exists on enterprise' do
      let(:manager) { Rewards::Points::Manager.new(user, 'unknown') }

      it 'does not gives the points of action to user' do
        expect { manager.remove_points(initiative) }
          .to_not change(UserRewardAction.where(user: user), :count)
      end

      it 'does not changes the points' do
        manager.remove_points(initiative)
        user.reload

        expect(user.points).to eq 5
      end

      it 'does not changes the credits' do
        manager.remove_points(initiative)
        user.reload

        expect(user.credits).to eq 10
      end
    end
  end
end

require 'rails_helper'

RSpec.describe ResetWeeklyRewardsJob, type: :job do
  let!(:user) { create(:user, total_weekly_points: 25) }
  let!(:group) { create(:group, total_weekly_points: 25) }
  let!(:user_group) { create(:User_group, total_weekly_points: 25) }

  it 'reset users weekly rewards' do
    Sidekiq::Testing.inline! do
      worker = ResetWeeklyRewardsJob.new
      worker.perform
      expect(user.total_weekly_points).to eq 0
    end
  end

  it 'reset groups weekly rewards' do
    Sidekiq::Testing.inline! do
      worker = ResetWeeklyRewardsJob.new
      worker.perform
      expect(group.total_weekly_points).to eq 0
    end
  end

  it 'reset user_groups weekly rewards' do
    Sidekiq::Testing.inline! do
      worker = ResetWeeklyRewardsJob.new
      worker.perform
      expect(user_group.total_weekly_points).to eq 0
    end
  end
end

class ResetWeeklyRewardsJob < ActiveJob::Base
  queue_as :default

  def perform
    User.update_all(total_weekly_points: 0)
    Group.update_all(total_weekly_points: 0)
    UserGroup.update_all(total_weekly_points: 0)
  end
end

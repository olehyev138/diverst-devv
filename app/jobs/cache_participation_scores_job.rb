class CacheParticipationScoresJob < ActiveJob::Base
  queue_as :default

  def perform
    User.all.each do |user|
      user.update(participation_score_7days: user.participation_score(from: 1.week.ago))
    end

    Group.all.each do |group|
      group.update(participation_score_7days: group.participation_score(from: 1.week.ago))
    end
  end
end

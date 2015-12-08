class CacheParticipationScoresJob < ActiveJob::Base
  queue_as :default

  def perform
    Employee.all.each do |employee|
      employee.update(participation_score_7days: employee.participation_score(from: 1.week.ago))
    end
  end
end

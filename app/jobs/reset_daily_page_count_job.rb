class ResetDailyPageCountJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    PageVisitationData.end_of_day_count
  end
end

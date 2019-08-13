class IncrementViewCountJob < ActiveJob::Base
  queue_as :low

  def perform(user, page, name, controller, action)
    record = PageVisitationData.find_by(user: user, page_url: page)
    if record.nil?
      record = PageVisitationData.new(user: user, page_url: page, controller: controller, action: action)
    end
    record.name = name
    record.visits_all += 1
    record.visits_day += 1
    record.visits_week += 1
    record.visits_month += 1
    record.visits_year += 1

    record.save
  end
end

class IncrementViewCountJob < ActiveJob::Base
  queue_as :low

  def perform(user_id, page, name, controller, action)
    if page == '/'
      page = Rails.application.routes.url_helpers.metrics_overview_index_path
    end

    record = PageVisitationData.find_by(user_id: user_id, page_url: page)
    if record.nil?
      record = PageVisitationData.new(user_id: user_id, page_url: page, controller: controller, action: action)
    end
    record.name = name
    record.controller = controller
    record.action = action
    record.visits_all += 1
    record.visits_day += 1
    record.visits_week += 1
    record.visits_month += 1
    record.visits_year += 1

    record.save
  end
end

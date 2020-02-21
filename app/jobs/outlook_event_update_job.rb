class OutlookEventUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(event_id)
    i = Initiative.find(event_id)
    i.initiative_users.batch_update
  end
end

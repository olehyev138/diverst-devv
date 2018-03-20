class PollUsersNotifierJob < ActiveJob::Base
  queue_as :default

  def perform(poll_id)
    poll = Poll.find_by_id poll_id

    return if poll.nil?

    Notifiers::PollNotifier.new(poll).notify!
  end
end

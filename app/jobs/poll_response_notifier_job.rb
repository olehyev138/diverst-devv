class PollResponseNotifierJob < ActiveJob::Base
  queue_as :mailers

  def perform(response_id)
    response = PollResponse.find_by(id: response_id)

    return if response.nil?

    Notifiers::ResponseNotifier.new(response_id).notify!
  end
end

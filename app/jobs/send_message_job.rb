class SendMessageJob < ActiveJob::Base
  queue_as :critical

  def perform(message)

  end
end

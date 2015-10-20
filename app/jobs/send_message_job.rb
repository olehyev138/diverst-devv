class SendMessageJob < ActiveJob::Base
  queue_as :default

  def perform(message)

  end
end

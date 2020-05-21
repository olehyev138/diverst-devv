class SendPollNotificationJob < ActiveJob::Base
  queue_as :mailers

  def perform
    Poll.joins(:initiative)
      .published
      .where(email_sent: false)
      .where('initiatives.end <= ?', Date.today)
      .each do |poll|
      Notifiers::PollNotifier.new(poll).notify!
    end
  end
end

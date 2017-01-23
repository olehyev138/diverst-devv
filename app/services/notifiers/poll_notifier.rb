class Notifiers::PollNotifier
  def initialize(poll)
    @poll = poll
  end

  def notify!
    if should_notify?
      @poll.targeted_users.each do |user|
        PollMailer.delay.invitation(@poll, user)
      end
      @poll.update(email_sent: true)
    end
  end

  private
  def should_notify?
    !@poll.email_sent && @poll.published?
  end
end

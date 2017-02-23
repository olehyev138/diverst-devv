class Notifiers::PollNotifier
  def initialize(poll)
    @poll = poll
  end

  def notify!
    if should_notify?
      targeted_users.each do |user|
        PollMailer.delay.invitation(@poll, user)
      end
      @poll.update(email_sent: true)
    end
  end

  private
  def should_notify?
    !@poll.email_sent && @poll.published?
  end

  def targeted_users
    users = @poll.targeted_users
    users = filter_by_initiative(users) if @poll.initiative
    users
  end

  def filter_by_initiative(users)
    initiative = @poll.initiative
    users.select{ |u| u.initiatives.where(id: initiative.id).any? }
  end
end

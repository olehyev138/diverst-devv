class Notifiers::PollNotifier
  def initialize(poll)
    @poll = poll
    @initiative = poll.initiative
  end

  def notify!
    if should_notify?
      targeted_users.each do |user|
        PollMailer.invitation(@poll, user).deliver_later
      end
      @poll.update(email_sent: true)
    end
  end

  private
  def should_notify?
    !@poll.email_sent && @poll.published? && initiative_ended_up?
  end

  def initiative_ended_up?
    return true unless @initiative
    @initiative.end <= Date.today
  end

  def targeted_users
    users = @poll.targeted_users
    users = filter_by_initiative(users) if @initiative
    users
  end

  def filter_by_initiative(users)
    users.select{ |u| u.initiatives.where(id: @initiative.id).any? }
  end
end

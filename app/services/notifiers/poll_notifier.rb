class Notifiers::PollNotifier
  def initialize(poll)
    @poll = poll
    @initiative = poll.initiative
  end

  def notify!
    if should_notify?
      targeted_users.find_each(batch_size: 100) do |user|
        PollMailer.invitation(@poll, user).deliver_later
        DeviceNotificationJob.perform_later(user.id, { "notification": {
          "title": @poll.title,
          "body": @poll.description,
          "org": 'diverst',
          "survey": ''
        } })
      end
      @poll.update(email_sent: true)
    end
  end

  private

  def should_notify?
    (!@poll.email_sent) && @poll.published? && initiative_ended_up?
  end

  def initiative_ended_up?
    return true unless @initiative

    @initiative.end <= Date.today
  end

  def targeted_users
    users = @poll.targeted_users
    users = filter_by_initiative(users) if @initiative
    User.where(id: users.map(&:id))
  end

  def filter_by_initiative(users)
    users.select { |u| u.initiatives.where(id: @initiative.id).any? }
  end
end

class Notifiers::PollNotifier
  def initialize(poll)
    @poll = poll
    @initiative = poll.initiative
  end

  def notify!
    token = targeted_tokens
    token.find_each(batch_size: 100) do |token|
      PollMailer.invitation(@poll, token.user).deliver_later
      DeviceNotificationJob.perform_later(token.user_id, { "notification": {
        "title": @poll.title,
        "body": @poll.description,
        "org": 'diverst',
        "survey": ''
      } })
    end
    token.update_all(email_sent: true)
    @poll.column_update(:email_sent, true)
  end

  private

  def should_notify?
    (!@poll.email_sent) && @poll.published? && initiative_ended_up?
  end

  def initiative_ended_up?
    return true unless @initiative

    @initiative.end <= Date.today
  end

  def targeted_tokens
    tokens = @poll.user_poll_tokens.preload(:user).where(email_sent: false)
    tokens = filter_by_initiative(tokens) if @initiative.present?
    tokens.distinct
  end

  def filter_by_initiative(tokens)
    tokens.joins(:user, user: [:initiatives]).where(initiatives: { id: @initiative.id })
  end
end

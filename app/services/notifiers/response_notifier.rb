class Notifiers::ResponseNotifier
  def initialize(response)
    @response = response
    @user = User.find_by(response.user_id)
    @poll = Poll.find_by(response.poll_id)
    @initiative = @poll.initiative
  end

  def notify!
    targeted_users.find_each(batch_size: 100) do |user|
      PollResponseMailer.notification(@response, user).deliver_later
    end
  end

  private

  def targeted_users
    users = @poll.targeted_users
    users = filter_by_initiative(users) if @initiative
    User.where(id: users.map(&:id))
  end

  def filter_by_initiative(users)
    users.select { |u| u.initiatives.where(id: @initiative.id).any? }
  end
end

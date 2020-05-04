class Notifiers::ResponseNotifier
  def initialize(response)
    @response = response
    @user = User.find_by(response.user_id)
    @poll = Poll.find_by(response.poll_id)
    @initiative = @poll.initiative
  end

  def notify!
    PollResponseMailer.notification(@response, @response.user)
  end
end

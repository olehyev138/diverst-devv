class Notifiers::ResponseNotifier
  def initialize(response_id)
    @response = PollResponse.find_by(id: response_id)
    @user = User.find_by(id: @response&.user_id)
  end

  def notify!
    PollResponseMailer.notification(@response.id, @user.id)
  end
end

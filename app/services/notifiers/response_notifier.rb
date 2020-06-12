class Notifiers::ResponseNotifier
  def initialize(response_id)
    @response = PollResponse.find_by(id: response_id)
    @user = User.find_by(id: @response&.user_id)
  end

  def notify!
    return if @response.nil? || @user.nil?

    PollResponseMailer.notification(@response.id, @user.id).deliver_later
  end
end

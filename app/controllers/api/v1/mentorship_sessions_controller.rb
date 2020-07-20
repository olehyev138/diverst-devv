class Api::V1::MentorshipSessionsController < DiverstController
  def accept
    item = get_item(params[:mentorship_session][:user_id], params[:mentorship_session][:mentoring_session_id])
    base_authorize(item)
    render status: 200, json: item.accept!
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  def decline
    item = get_item(params[:mentorship_session][:user_id], params[:mentorship_session][:mentoring_session_id])
    base_authorize(item)
    render status: 200, json: item.decline!
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  protected

  def get_item(user_id, session_id)
    item = klass.find_by(user_id: user_id, mentoring_session_id: session_id)

    raise "User doesn't exist" unless User.exists?(user_id)
    raise "Mentorship Session doesn't exist" unless MentoringSession.exists?(session_id)
    raise 'User was not invited to Mentorship Session' if item.blank?

    item
  end
end

class Api::V1::MentoringsController < DiverstController
  def delete_mentorship
    mentorship = Mentoring.find_by(mentor_id: payload[:mentor_id], mentee_id: payload[:mentee_id])
    if mentorship.present?
      begin
        base_authorize mentorship
        mentorship.destroy

        head :no_content
      rescue => e
        raise BadRequestException.new(e.message)
      end
    else
      raise BadRequestException.new('Mentorship doesn\'t exist')
    end
  end
end

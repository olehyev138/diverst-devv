class Api::V1::MentoringsController < DiverstController
  def delete_mentorship
    mentor = User.find(payload[:mentor_id])
    mentee = User.find(payload[:mentor_id])

    if mentee && mentor
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
        raise BadRequestException.new('Mentorship does\'t exist')
      end
    else
      raise BadRequestException.new('One of the users does\'t exist')
    end
  end
end

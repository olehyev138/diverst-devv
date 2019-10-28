class Api::V1::MentoringsController < DiverstController
  def delete_mentorship
    # authorize [@group, @member], :destroy?, policy_class: GroupMemberPolicy - TODO
    mentor = User.find(payload[:mentor_id])
    mentee = User.find(payload[:mentor_id])

    if mentee && mentor
      begin
        mentorship = Mentoring.find_by(mentor_id: payload[:mentor_id], mentee_id: payload[:mentee_id])
        mentorship.destroy if mentorship
      rescue => e
        raise BadRequestException.new(e.message)
      end
    else
      # TODO: done properly?
      raise BadRequestException.new('Mentorship doesnt exist')
    end

    # if we made it here - were good
    render status: 204, json: {}
  end
end

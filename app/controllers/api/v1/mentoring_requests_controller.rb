class Api::V1::MentoringRequestsController < DiverstController
  def accept
    item = klass.find(params[:id])
    base_authorize(item)

    new_params = {
      id: params[:id],
      klass.symbol => {
        status: 'accepted'
      }
    }

    request = klass.update(self.diverst_request, new_params)
    mentor_id = request.type == 'mentor' ? request.receiver_id : request.sender_id
    mentee_id = request.type == 'mentor' ? request.sender_id : request.receiver_id

    Mentoring.build(self.diverst_request, {
      mentoring: {
        mentor_id: mentor_id,
        mentee_id: mentee_id
      }
    })
    render status: 200, json: request
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  def deny
    item = klass.find(params[:id])
    base_authorize(item)

    new_params = {
      id: params[:id],
      klass.symbol => {
        status: 'denied'
      }
    }

    render status: 200, json: klass.update(self.diverst_request, new_params)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end
end

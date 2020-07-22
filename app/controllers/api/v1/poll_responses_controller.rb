class Api::V1::PollResponsesController < DiverstController
  skip_before_action :verify_jwt_token, only: [
      :questionnaire,
      :create
  ]

  def questionnaire
    token = params[:token]
    second_token, prototype = PollTokenService.submission_jwt_token(token)

    render status: 200, json: {
        token: second_token,
        response: PollResponseSerializer.new(prototype).as_json,
    }
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def create
    response_params = params[:poll_response]
    token = response_params[:token]
    poll_token = PollTokenService.verify_jwt_token(token, 'response')
    response_params[:poll_id] = poll_token.poll_id
    response_params[:user_id] = poll_token.user_id unless response_params[:anonymous]
    params[klass.symbol] = payload

    new_item = klass.build(self.diverst_request, params)
    poll_token.update(submitted: true)
    render status: 201, json: new_item
  rescue => e
    case e
    when InvalidInputException, Pundit::NotAuthorizedError then raise
    else raise BadRequestException.new(e.message)
    end
  end

  private

  def payload
    params
        .require(:poll_response)
        .permit(
            :anonymous,
            :poll_id,
            :user_id,
            field_data_attributes: [
                :data,
                :field_id
            ]
          )
  end
end

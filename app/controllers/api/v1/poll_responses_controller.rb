class Api::V1::PollResponsesController < DiverstController
  def questionnaire
    token = params[:token]
    second_token, prototype = PollTokenService.second_jwt(token)

    base_authorize(klass)
    render status: 200, json: {
        token: second_token,
        response: prototype,
    }
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def create
    if params[:poll_response]
      response_params = params[:poll_response]
      token = response_params[:token]
      poll_token = PollTokenService.verify_jwt_token(token, 'response')
      response_params[:poll_id] = poll_token.poll_id
      response_params[:user_id] = poll_token.user_id unless response_params[:anonymous]
    end
    super
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
            ]
          )
  end
end

class Api::V1::PollResponsesController < DiverstController
  def payload
    params
    .require('custom-fields')

    params.require(:poll_response).permit(:anonymous, :poll_id)
  end
end

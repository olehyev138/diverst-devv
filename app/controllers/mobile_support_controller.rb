class MobileSupportController < DiverstController
  #
  # TODO (DI-844): - AASA is a temporary mobile appeasement
  #   - updates will be needed to support multiple clients, etc

  # skip filter for specific actions
  skip_before_action :verify_jwt_token, only: [:routing_error, :render_aasa]
  skip_before_action :verify_api_key, only: [:render_aasa]

  # TODO (DI-844): - temporary mobile appeasement for apple store
  def render_aasa
    render json: File.read(Rails.root.join('public', 'aasa'))
  end
end

class Api::V1::InitiativesController < DiverstController
  def generate_qr_code
    render status: 200, json: klass.generate_qr_code(diverst_request, params)
  rescue => e
    raise BadRequestException.new(e.message)
  end
end

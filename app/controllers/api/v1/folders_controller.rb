class Api::V1::FoldersController < DiverstController
  def validate_password
    render json: klass.validate_password(self.diverst_request.user, params)
  rescue => e
    raise BadRequestException.new(e.message)
  end
end

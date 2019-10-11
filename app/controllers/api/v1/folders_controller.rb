class Api::V1::FoldersController < DiverstController
  def validate_password
    render json: klass.validate_password(self.diverst_request.user, params)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def payload
    params.require(:folder).permit(
      klass.attribute_names - %w(id created_at updated_at enterprise_id) + ['password']
    )
  end
end

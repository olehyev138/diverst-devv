class Api::V1::EnterprisesController < DiverstController
  skip_before_action :verify_api_key, only: [:sso_login, :sso_link]
  skip_before_action :verify_jwt_token, only: [:sso_login, :sso_link]

  def sso_login
    redirect_to klass.sso_login(self.diverst_request, params)
  rescue => e
    redirect_to "#{ENV['DOMAIN']}/login?errorMessage=#{e.message}"
  end

  def sso_link
    render status: 200, json: klass.sso_link(self.diverst_request, params)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def get_enterprise
    enterprise = self.diverst_request.user.enterprise
    base_authorize(enterprise)

    render status: 200, json: enterprise
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def update_enterprise
    params[klass.symbol] = payload

    enterprise = Enterprise.find(diverst_request.user.enterprise.id)
    base_authorize(enterprise)

    render status: 200, json: enterprise.update(params[:enterprise])
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  def fields
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: Field.index(self.diverst_request, params.except(:id).permit!, base: item.fields)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def create_field
    params[:field] = field_payload
    base_authorize(klass)
    item = klass.find(params[:id])
    new_field = Field.build(self.diverst_request, params)
    item.fields << new_field

    render status: 201, json: new_field
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  def field_payload
    params
        .require(:field)
        .permit(
            :type,
            :title,
            :options_text,
            :min,
            :max,
          )
  end
end

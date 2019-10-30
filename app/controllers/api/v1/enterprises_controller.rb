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
    render status: 200, json: diverst_request.user.enterprise
  end

  def update_enterprise
    params[klass.symbol] = payload.except(:id)
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
end

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

  def show
    render status: 200, json: diverst_request.user.enterprise
  end

  def update
    params[klass.symbol] = payload.except(:id)
    enterprise = Enterprise.find(diverst_request.user.enterprise.id)

    if enterprise.update(params[:enterprise])
      render status: 200
    else
      raise BadRequestException.new('Failed to update enterprise')
    end
  end
end

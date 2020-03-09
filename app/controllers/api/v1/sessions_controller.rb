class Api::V1::SessionsController < DiverstController
  skip_before_action :verify_jwt_token, only: [:create]

  def create
    user = User.signin(params[:email], params[:password])

    render status: 200, json: {
      token: UserTokenService.create_jwt(user, params),
      user_id: user.id,
      enterprise: AuthenticatedEnterpriseSerializer.new(user.enterprise).as_json,
      policy_group: PolicyGroupSerializer.new(user.policy_group).as_json,
      email: user.email,
      role: user.user_role.role_name,
      time_zone: ActiveSupport::TimeZone.find_tzinfo(user.time_zone).name,
      created_at: user.created_at.as_json,
    }
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def logout
    render status: 200, json: klass.logout(request.headers['Diverst-UserToken'])
  rescue => e
    raise BadRequestException.new(e.message)
  end
end

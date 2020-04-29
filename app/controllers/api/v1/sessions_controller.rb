class Api::V1::SessionsController < DiverstController
  skip_before_action :verify_jwt_token, only: [:create, :logout]

  def create
    user = User.signin(params[:email], params[:password])

    track_activity(user, { ip: user.current_sign_in_ip }, user: user) if user.present?

    render status: 200, json: {
      token: UserTokenService.create_jwt(user, params),
    }
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def logout
    render status: 200, json: klass.logout(request.headers['Diverst-UserToken'])
  rescue => e
    raise BadRequestException.new('User not logged in')
  end

  private def action_map(action)
    case action
    when :create then 'login'
    else nil
    end
  end
end

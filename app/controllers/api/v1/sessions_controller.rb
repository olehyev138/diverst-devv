class Api::V1::SessionsController < DiverstController
  skip_before_action :verify_jwt_token, only: [:create]

  def create
    user = User.signin(params[:email], params[:password])
    render status: 200, json: { token: UserTokenService.create_jwt(user, params) }
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def destroy
    render status: 200, json: klass.destroy(self.diverst_request, params)
  rescue => e
    raise BadRequestException.new(e.message)
  end
end

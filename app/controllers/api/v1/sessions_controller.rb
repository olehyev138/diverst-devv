class Api::V1::SessionsController < DiverstController
  skip_before_action :verify_jwt_token, only: [:create]

  def create
    user = User.signin(params[:email], params[:password])
    render status: 200, json: { token: UserTokenService.create_jwt(user, params) }
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def destroy
    session = Session.find_by_token(params[:id])
    if session.nil?
      render status: 404, json: { message: 'Invalid user Token' }
    else
      session.update(status: 1)
      render status: 200, json: { token: params[:id] }
    end
  rescue => e
    raise BadRequestException.new(e.message)
  end
end

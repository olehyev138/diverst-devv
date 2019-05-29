class Api::V1::UsersController < DiverstController
  skip_before_action :verify_jwt_token, only: [:find_user_by_email]

  def find_user_by_email
    render json: User.find_user_by_email(self.diverst_request.user, params)
  end
end

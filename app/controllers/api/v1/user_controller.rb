class Api::V1::UserController < DiverstController
  def get_posts
    render json: klass.posts(self.diverst_request.user, params)
  rescue => e
    raise BadRequestException.new(e.message)
  end
end

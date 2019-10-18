class Api::V1::UserController < DiverstController
  def get_posts
    render json: klass.posts(self.diverst_request.user, params)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def get_joined_events
    render json: klass.joined_events(self.diverst_request.user, params)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def get_all_events
    render json: klass.all_events(self.diverst_request.user, params)
  rescue => e
    raise BadRequestException.new(e.message)
  end
end

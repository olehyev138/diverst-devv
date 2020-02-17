class Api::V1::UserController < DiverstController
  def get_posts
    render json: current_user.posts(params)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def get_joined_events
    render json: diverst_request.user.joined_events(params)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def get_all_events
    render json: diverst_request.user.all_events(params)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def get_downloads
    render json: diverst_request.user.downloads(params)
  rescue => e
    raise BadRequestException.new(e.message)
  end
end

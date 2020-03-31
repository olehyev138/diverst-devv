class Api::V1::UserController < DiverstController
  def get_posts
    render json: current_user.posts(params)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def get_downloads
    render json: diverst_request.user.downloads(params)
  rescue => e
    raise BadRequestException.new(e.message)
  end
end

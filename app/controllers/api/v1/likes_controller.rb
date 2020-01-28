class Api::V1::LikesController < DiverstController
  def unlike
    render status: 200, json: {works: true}
  end

  def payload
    params

  end
end

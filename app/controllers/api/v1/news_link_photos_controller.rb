class Api::V1::NewsLinkPhotosController < DiverstController
  def payload
    params
      .require(:news_link_photo)
      .permit(
        :news_link_id,
        :file,
      )
  end
end

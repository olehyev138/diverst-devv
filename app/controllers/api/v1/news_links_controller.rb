class Api::V1::NewsLinksController < DiverstController
  def payload
    params
      .require(:news_link)
      .permit(
        :url,
        :title,
        :description,
        :picture,
        :group_id,
        :author_id,
        photos_attributes: [:file, :_destroy, :id],
        news_feed_link_attributes: [:id, :approved, :news_feed_id, :link, shared_news_feed_ids: [], segment_ids: []],
      )
  end
end

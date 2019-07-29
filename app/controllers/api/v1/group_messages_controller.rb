class Api::V1::GroupMessagesController < DiverstController
  def payload
    params
      .require(:group_message)
      .permit(
        :subject,
        :group_id,
        :owner_id,
        :content,
        news_feed_link_attributes: [:id, :approved, :news_feed_id, :link, shared_news_feed_ids: [], segment_ids: []],
      )
  end
end

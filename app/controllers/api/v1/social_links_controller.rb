class Api::V1::SocialLinksController < DiverstController
  def klass
    'SocialLink'.classify.constantize
  end

  def payload
    params
    .require(:social_link)
    .permit(
      :url,
      :author_id,
      :group_id,
      news_feed_link_attributes: [:id, :approved, :news_feed_id, :link, shared_news_feed_ids: [], segment_ids: []],
    )
  end

  def action_map(action)
    case action
    when :create then 'create'
    when :destroy then 'destroy'
    else nil
    end
  end
end

class GroupMessageSerializer < ApplicationRecordSerializer
  attributes :news_feed_link_id, :owner

  attributes_with_permission :comments, if: :show_action?

  def comments
    object.comments.map do |comment|
      GroupMessageCommentSerializer.new(comment, **instance_options).as_json
    end
  end

  def news_feed_link_id
    object.news_feed_link.id
  end

  def serialize_all_fields
    true
  end
end

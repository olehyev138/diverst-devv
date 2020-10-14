class NewsLinkSerializer < ApplicationRecordSerializer
  attributes :author, :photos, :picture_location, :news_feed_link_id

  attributes_with_permission :comments, if: :show_action?

  def comments
    object.comments.map do |comment|
      NewsLinkCommentSerializer.new(comment, **instance_options).as_json
    end
  end

  def picture_location
    object.picture_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def photos
    object.photos.map do |photo|
      NewsLinkPhotoSerializer.new(photo, scope: scope, root: false).as_json
    end
  end

  def news_feed_link_id
    object.news_feed_link.id
  end

  def serialize_all_fields
    true
  end
end

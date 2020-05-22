class NewsLinkSerializer < ApplicationRecordSerializer
  attributes :author, :photos, :picture_location, :news_feed_link_id
  has_many :comments

  def picture_location
    object.picture_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def photos
    object.photos.map do |photo|
      NewsLinkPhotoSerializer.new(photo, scope: scope, root: false)
    end
  end

  def news_feed_link_id
    news_feed_link.id
  end

  def serialize_all_fields
    true
  end
end

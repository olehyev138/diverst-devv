class NewsLinkSerializer < ApplicationRecordSerializer
  attributes :group, :author, :photos, :news_feed_link, :picture_location
  has_many :comments

  def picture_location
    object.picture_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def photos
    object.photos.map do |photo|
      NewsLinkPhotoSerializer.new(photo, scope: scope, root: false)
    end
  end

  def serialize_all_fields
    true
  end
end

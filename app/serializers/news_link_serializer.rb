class NewsLinkSerializer < ApplicationRecordSerializer
  attributes :group, :author, :photos, :news_feed_link, :picture_location

  def photos
    object.photos.map do |photo|
      NewsLinkPhotoSerializer.new(photo, scope: scope, root: false)
    end
  end

  def serialize_all_fields
    true
  end
end

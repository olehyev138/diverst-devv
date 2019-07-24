class Sponsor < ApplicationRecord
  belongs_to :sponsorable, polymorphic: true

  has_attached_file :sponsor_media, s3_permissions: :private
  do_not_validate_attachment_file_type :sponsor_media

  def sponsor_media_url=(url)
    self.sponsor_media = URI.parse(url)
  end

  def sponsor_media_location
    return nil if !sponsor_media.presence

    sponsor_media.expiring_url(36000)
  end

  def enterprise
    return nil if sponsorable_type != 'Enterprise'

    sponsorable
  end

  def group
    return nil if sponsorable_type != 'Group'

    sponsorable
  end
end

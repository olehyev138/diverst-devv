class Sponsor < ActiveRecord::Base
  belongs_to :sponsorable, polymorphic: true

  has_attached_file :sponsor_media, s3_permissions: :private
  do_not_validate_attachment_file_type :sponsor_media
end

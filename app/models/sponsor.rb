class Sponsor < BaseClass
  belongs_to :enterprise
  belongs_to :group
  belongs_to :campaign

  has_attached_file :sponsor_media, s3_permissions: :private
  do_not_validate_attachment_file_type :sponsor_media
  validates_length_of :sponsor_media_content_type, maximum: 191
  validates_length_of :sponsor_media_file_name, maximum: 191
  validates_length_of :sponsor_message, maximum: 65535
  validates_length_of :sponsor_title, maximum: 191
  validates_length_of :sponsor_name, maximum: 191
end

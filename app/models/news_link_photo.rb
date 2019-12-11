class NewsLinkPhoto < ApplicationRecord
  belongs_to :news_link

  validates :news_link, presence: true, on: :update

  # ActiveStorage
  has_one_attached :file
  validates :file, attached: true, content_type: AttachmentHelper.common_image_types

  # TODO Remove after Paperclip to ActiveStorage migration
  has_attached_file :file_paperclip, s3_permissions: 'private'

  def file_location(expires_in: 3600, default_style: :medium)
    return nil if !file.attached?

    # default_style = :medium if !file.styles.keys.include? default_style
    # file.expiring_url(expires_in, default_style)
    Rails.application.routes.url_helpers.url_for(file)
  end

  def group
    news_link.group
  end
end

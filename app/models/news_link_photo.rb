class NewsLinkPhoto < ApplicationRecord
  belongs_to :news_link

  validates :news_link, presence: true, on: :update

  # ActiveStorage
  has_one_attached :file
  validates :file, attached: true, content_type: AttachmentHelper.common_image_types

  # Paperclip TODO
  # has_attached_file :file, styles: { medium: '1000x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing_user.png'), s3_permissions: :private
  # validates_attachment_content_type :file, content_type: %r{\Aimage\/.*\Z}

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

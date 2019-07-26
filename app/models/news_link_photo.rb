class NewsLinkPhoto < ApplicationRecord
  belongs_to :news_link

  validates :news_link, presence: true, on: :update

  # Paperclip
  has_attached_file :file, styles: { medium: '1000x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing_user.png'), s3_permissions: :private
  validates_attachment_content_type :file, content_type: %r{\Aimage\/.*\Z}

  def file_url=(url)
    self.file = URI.parse(url)
  end

  def file_location
    return nil if !file.presence

    file.expiring_url(36000)
  end

  def group
    news_link.group
  end
end

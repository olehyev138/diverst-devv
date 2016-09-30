class NewsLink < ActiveRecord::Base
  belongs_to :group

  before_validation :smart_add_url_protocol

  has_many :comments, class_name: 'NewsLinkComment'

  has_attached_file :picture, styles: { medium: '1000x300>', thumb: '100x100>' }, s3_permissions: :private
  validates_attachment_content_type :picture, content_type: %r{\Aimage\/.*\Z}

  protected

  def smart_add_url_protocol
    self.url = "http://#{url}" unless url[%r{\Ahttp:\/\/}] || url[%r{\Ahttps:\/\/}]
  end
end

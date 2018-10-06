class AdditionalEnterpriseSponsor < ActiveRecord::Base
  belongs_to :enterprise

  has_attached_file :sponsor_image, styles: { medium: '1000x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing.png'), s3_permissions: :private
  validates_attachment_content_type :sponsor_image, content_type: %r{\Aimage\/.*\Z}
end

class Badge < ActiveRecord::Base
  belongs_to :enterprise

  validates :label, presence: true
  validates :points, numericality: { only_integer: true }, presence: true
  validates :enterprise, presence: true
  has_attached_file :image, styles: { thumb: '120x120>' }
  validates_attachment_presence :image
  validates_attachment_content_type :image, content_type: %r{\Aimage\/.*\Z}
end

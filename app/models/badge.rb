class Badge < BaseClass
  include PublicActivity::Common

  belongs_to :enterprise

  validates_length_of :image_content_type, maximum: 191
  validates_length_of :image_file_name, maximum: 191
  validates_length_of :label, maximum: 191
  validates :label, presence: true
  validates :points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
  validates :enterprise, presence: true
  has_attached_file :image, styles: { thumb: '120x120>' }
  validates_attachment_presence :image
  validates_attachment_content_type :image, content_type: %r{\Aimage\/.*\Z}
end

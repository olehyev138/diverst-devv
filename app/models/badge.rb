class Badge < ApplicationRecord
  include PublicActivity::Common

  belongs_to :enterprise

  validates_length_of :label, maximum: 191
  validates :label, presence: true
  validates :points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
  validates :enterprise, presence: true

  # ActiveStorage
  has_one_attached :image
  validates :image, attached: true, content_type: AttachmentHelper.common_image_types

  # TODO Remove after Paperclip to ActiveStorage migration
  has_attached_file :image_paperclip
end

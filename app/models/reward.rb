class Reward < ApplicationRecord
  include PublicActivity::Common

  belongs_to :enterprise
  belongs_to :responsible, class_name: 'User', foreign_key: 'responsible_id'

  # ActiveStorage
  has_one_attached :picture
  validates :picture, content_type: AttachmentHelper.common_image_types

  # TODO Remove after Paperclip to ActiveStorage migration
  has_attached_file :picture_paperclip

  validates_length_of :description, maximum: 65535
  validates_length_of :label, maximum: 191
  validates :enterprise, presence: true
  validates :points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
  validates :label, presence: true
  validates :responsible, presence: true
  validate :responsible_user

  private

  def responsible_user
    errors.add(:responsible_id, 'Invalid responsible') unless responsible.try(:enterprise) == enterprise
  end
end

class ExpenseCategory < ApplicationRecord
  include PublicActivity::Common

  belongs_to :enterprise
  has_many :expenses, dependent: :destroy, foreign_key: :category_id

  # ActiveStorage
  has_one_attached :icon
  validates :icon, content_type: AttachmentHelper.common_image_types

  # TODO Remove after Paperclip to ActiveStorage migration
  has_attached_file :icon_paperclip, s3_permissions: 'private'

  validates :name,        presence: true
  validates :enterprise,  presence: true
end

class ExpenseCategory < ApplicationRecord
  include PublicActivity::Common

  belongs_to :enterprise
  has_many :expenses, dependent: :destroy, foreign_key: :category_id

  # ActiveStorage
  has_one_attached :icon
  validates :icon, content_type: AttachmentHelper.common_image_types

  validates :name,        presence: true
  validates :enterprise,  presence: true
end

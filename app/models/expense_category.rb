class ExpenseCategory < BaseClass
  include PublicActivity::Common

  belongs_to :enterprise
  has_many :expenses, dependent: :destroy, foreign_key: :category_id

  has_attached_file :icon, styles: { thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing.png'), s3_permissions: 'private'
  validates_attachment_content_type :icon, content_type: %r{\Aimage\/.*\Z}

  validates :name,        presence: true
  validates :enterprise,  presence: true
end

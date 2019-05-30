class Reward < ApplicationRecord
  include PublicActivity::Common

  belongs_to :enterprise
  belongs_to :responsible, class_name: 'User', foreign_key: 'responsible_id'
  # Paperclip
  # has_attached_file :picture,
  #                    styles: { thumb: '120x120>' },
  #                    default_url: ActionController::Base.helpers.image_path('/assets/missing.png')

  # validates_attachment_content_type :picture, content_type: %r{\Aimage\/.*\Z}
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

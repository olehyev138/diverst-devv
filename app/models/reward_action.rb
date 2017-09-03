class RewardAction < ActiveRecord::Base
  belongs_to :enterprise

  validates :label, presence: true
  validates :key, presence: true
  validates :points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end

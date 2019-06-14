class RewardAction < BaseClass
  belongs_to :enterprise

  validates_length_of :key, maximum: 191
  validates_length_of :label, maximum: 191
  validates :label, presence: true
  validates :key, presence: true
  validates :points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end

class RewardAction < ActiveRecord::Base
  validates :label, presence: true
  validates :key, presence: true
  validates :points, numericality: { only_integer: true }, allow_nil: true
end

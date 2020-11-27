class GroupCategory < ApplicationRecord
  include GroupCategory::Actions

  # NOTE: on user-interface, this entity is references as label
  has_many :groups
  belongs_to :group_category_type
  belongs_to :enterprise
  validates :name, presence: true

  before_destroy :check_if_used

  def total_groups
    groups.size
  end

  def to_s
    name
  end

  def check_if_used
    if groups.any?
      errors.add(:base, "Can't delete category in use")
      throw(:abort)
    end
  end
end

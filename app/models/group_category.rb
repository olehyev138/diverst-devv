class GroupCategory < ApplicationRecord
  # NOTE: on user-interface, this entity is references as label
  has_many :groups, dependent: :nullify
  belongs_to :group_category_type
  belongs_to :enterprise
  validates :name, presence: true

  def total_groups
    groups.size
  end

  def to_s
    name
  end
end

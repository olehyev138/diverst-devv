class GroupCategory < ActiveRecord::Base
  has_many :groups
  belongs_to :group_category_type

  validates :name, presence: true
end

class GroupCategory < ActiveRecord::Base
  has_many :sub_group_categories, dependent: :destroy

  validates :type, presence: true

  def sub_categories
  end
end

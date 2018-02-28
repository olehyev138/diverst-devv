class GroupCategory < ActiveRecord::Base
  #NOTE: on user-interface, this entity is references as label
  has_many :groups
  belongs_to :group_category_type

  validates :name, presence: true


  def to_s
  	name
  end
end

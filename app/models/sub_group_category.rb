class SubGroupCategory < ActiveRecord::Base
  has_many :groups
  belongs_to :group_category 

  validates :name, presence: true

  def groups 
  	self.groups
  end 

  def category_type 
  	group_category.type
  end
end

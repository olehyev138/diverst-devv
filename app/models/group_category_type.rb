class GroupCategoryType < ActiveRecord::Base
  has_many :group_categories, dependent: :destroy
  has_many :groups
  belongs_to :enterprise

  validates :name, presence: true
  attr_accessor :category_names

  after_create :create_association_with_enterprise

  def category_names=(names)
  	@category_names = names
  	names.split(',').each do |name|
      self.group_categories << GroupCategory.find_or_create_by(name: name)
  	end
  end

  def to_s 
  	name
  end

  def create_association_with_enterprise
  	self.group_categories.update_all(enterprise_id: self.enterprise_id)
  end
end

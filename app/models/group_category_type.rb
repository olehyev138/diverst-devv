class GroupCategoryType < ActiveRecord::Base
  has_many :group_categories, dependent: :destroy
  has_many :groups

  validates :name, presence: true
  attr_accessor :category_names

  def category_names=(names)
  	@category_names = names
  	names.split(',').each do |name|
      self.group_categories << GroupCategory.find_or_create_by(name: name)
  	end
  end

  def to_s 
  	name
  end
end

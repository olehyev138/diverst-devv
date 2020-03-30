class GroupCategoryType < ApplicationRecord
  # NOTE: on user-interface, this entity is referenced as category
  has_many :group_categories, dependent: :delete_all
  has_many :groups, dependent: :nullify
  belongs_to :enterprise

  validates_length_of :name, maximum: 191
  validates :name, presence: true
  validates :name, uniqueness: true
  accepts_nested_attributes_for :group_categories, allow_destroy: true

  after_save :create_association_with_enterprise, on: [:create, :update]

  def to_s
    name
  end


  private

  def create_association_with_enterprise
    self.group_categories.update_all(enterprise_id: self.enterprise_id) if !self.enterprise_id.nil?
  end
end

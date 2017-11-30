class Folder < ActiveRecord::Base

  # associations
  belongs_to  :container, polymorphic: true
  has_many    :resources, as: :container
  has_many    :folder_shares
  has_many    :groups, through: :folder_shares, source: "container", source_type: 'Group'

  # validations
  validates :name, presence: true
  validates :container, presence: true
  validates_uniqueness_of :name, scope: [:container]

end

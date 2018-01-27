class GroupLeader < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates_presence_of :position_name
  validates_presence_of :group
  validates_presence_of :user

  scope :visible, ->{ where(visible: true) }
  # validates_uniqueness_of :group_contact, scope: :group_id, conditions: -> { where(group_contact: true) }
end

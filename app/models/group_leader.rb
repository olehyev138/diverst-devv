class GroupLeader < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates_presence_of :position_name
  validates_presence_of :group
  validates_presence_of :user

  scope :visible, ->{ where(visible: true) }
  
  validates_uniqueness_of :default_group_contact, scope: :group_id, conditions: -> { where(default_group_contact: true) },
  :message => "You can choose ONLY ONE leader as the contact for this group"
  
  after_save :set_group_contact
  
  def set_group_contact
    if default_group_contact
      group.contact_email = user.email
      group.save!
    end
  end
end

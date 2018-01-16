class GroupLeader < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates_presence_of :position_name
  validates_presence_of :group
  validates_presence_of :user

  scope :visible, ->{ where(visible: true) }

  def notifications_enabled_status
    if notifications_enabled?
      "On"
    else
      "Off"
    end
  end
end

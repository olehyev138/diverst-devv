class GroupMessage < ActiveRecord::Base
  has_many :group_messages_segments
  has_many :segments, through: :group_messages_segments
  belongs_to :group

  after_create :send_emails

  def users
    if segments.empty?
      group.members
    else
      User
        .joins(:groups, :segments)
        .where(
          'groups.id' => group.id,
          'segments.id' => segments.ids
        )
    end
  end

  def send_emails
    GroupMailer.delay.group_message(self)
  end
end

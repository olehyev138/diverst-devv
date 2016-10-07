class GroupMessage < ActiveRecord::Base
  has_many :group_messages_segments
  has_many :segments, through: :group_messages_segments
  has_many :comments, class_name: 'GroupMessageComment', foreign_key: :message_id
  belongs_to :owner, class_name: 'User'
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

  def owner_name
    return 'Unknown' unless owner.present?

    owner.first_name + owner.last_name
  end

  def send_emails
    GroupMailer.group_message(self).deliver_later
  end
end

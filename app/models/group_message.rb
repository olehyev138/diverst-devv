class GroupMessage < ActiveRecord::Base
  has_and_belongs_to_many :segments
  belongs_to :group

  after_create :send_emails

  def employees
    if segments.empty?
      self.group.members
    else
      Employee
      .joins(:groups, :segments)
      .where(
        "groups.id" => self.group.id,
        "segments.id" => self.segments.ids
      )
    end
  end

  def send_emails
    GroupMailer.delay.group_message(self)
  end
end
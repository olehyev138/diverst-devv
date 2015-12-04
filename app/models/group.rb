class Group < ActiveRecord::Base
  has_many :employee_groups, dependent: :destroy
  has_many :members, through: :employee_groups, class_name: "Employee", source: :employee
  belongs_to :enterprise
  has_and_belongs_to_many :polls
  has_many :events
  has_many :messages, class_name: "GroupMessage"
  has_many :news_links
  has_and_belongs_to_many :invitation_segments, class_name: "Segment", join_table: "invitation_segments_groups"
  has_many :resources, as: :container

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: ActionController::Base.helpers.image_path("missing.png")
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  before_save :send_invitation_emails, if: :send_invitations?

  protected

  def send_invitation_emails
    GroupMailer.delay.invitation(self, self.invitation_segments)
    self.send_invitations = false
    self.invitation_segments.clear
  end
end

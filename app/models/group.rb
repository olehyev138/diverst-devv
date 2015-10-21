class Group < ActiveRecord::Base
  has_many :employee_groups
  has_many :members, through: :employee_groups, class_name: "Employee", source: :employee
  belongs_to :enterprise
  has_and_belongs_to_many :polls
  has_many :events
  has_many :messages, class_name: "GroupMessage"
  has_many :news_links
  has_and_belongs_to_many :invitation_segments, class_name: "Segment", join_table: "invitation_segments_groups"

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: ActionController::Base.helpers.image_path("missing.png")
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  after_create :send_invitation_emails, if: :send_invitations?

  def employees_to_invite
    query = self.enterprise.employees

    unless invitation_segments.empty?
      query = query
      .joins(:segments)
      .where(
        "segments.id" => self.invitation_segments.ids
      )
    end

    query
  end

  protected

  def send_invitation_emails
    GroupMailer.delay.invitation(self)
  end
end

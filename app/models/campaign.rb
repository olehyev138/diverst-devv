class Campaign < ActiveRecord::Base
  belongs_to :enterprise
  has_many :questions
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :segments
  has_many :invitations, class_name: "CampaignInvitation"
  has_many :employees, through: :invitations

  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: ActionController::Base.helpers.image_path("missing.png")
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  after_create :create_invites

  def create_invites
    enterprise.employees.for_groups(self.groups).each do |employee_to_invite|
      self.invitations.create(employee: employee_to_invite)
    end
  end
end

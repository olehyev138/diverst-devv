class InitiativeComment < BaseClass
  belongs_to :user
  belongs_to :initiative

  has_many :user_reward_actions

  validates_length_of :content, maximum: 65535
  validates :user, presence: true
  validates :initiative, presence: true
  validates :content, presence: true

  before_create :approve_comment

  def group
    initiative.group
  end

  def disapproved?
    !approved?
  end

  def self.approved
    where(approved: true)
  end

  private

  def approve_comment
    self.approved = true
  end
end

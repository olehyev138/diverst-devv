class InitiativeComment < ApplicationRecord
  belongs_to :user
  belongs_to :initiative

  has_many :user_reward_actions

  validates_length_of :content, maximum: 65535
  validates :user, presence: true
  validates :initiative, presence: true
  validates :content, presence: true

  delegate :name, to: :user, prefix: true

  def group
    initiative.group
  end

  def disapproved?
    !approved?
  end

  def self.approved
    where(approved: true)
  end
end

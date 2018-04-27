class InitiativeComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :initiative

  validates :user, presence: true
  validates :initiative, presence: true
  validates :content, presence: true

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

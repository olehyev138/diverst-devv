class GroupMessageComment < ActiveRecord::Base
  belongs_to :author, class_name: 'User'
  belongs_to :message, class_name: 'GroupMessage'
  
  has_many :user_reward_actions
  
  validates :author, presence: true
  validates :message, presence: true
  validates :content, presence: true

  scope :unapproved, -> {where(:approved => false)}
  scope :approved, -> {where(:approved => true)}

  def group
    message.group
  end
end

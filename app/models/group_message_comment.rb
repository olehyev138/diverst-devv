class GroupMessageComment < ActiveRecord::Base
  belongs_to :author, class_name: 'User'
  belongs_to :message, class_name: 'GroupMessage'

  validates :author, presence: true
  validates :message, presence: true
  validates :content, presence: true
  
  scope :unapproved, -> {where(:approved => false)}
  scope :approved, -> {where(:approved => true)}

  def group
    message.group
  end
end

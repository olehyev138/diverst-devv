class AnswerComment < ActiveRecord::Base
  belongs_to :author, class_name: 'User', inverse_of: :answers
  belongs_to :answer, inverse_of: :comments

  has_many :user_reward_actions

  validates :author, presence: true
  validates :answer, presence: true
  validates :content, presence: true

  scope :unapproved, -> {where(:approved => false)}
end

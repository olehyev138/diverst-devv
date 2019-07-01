class AnswerComment < BaseClass
  include PublicActivity::Common

  belongs_to :author_id, class_name: 'User', inverse_of: :answers
  belongs_to :answer, inverse_of: :comments

  has_many :user_reward_actions

  validates_length_of :content, maximum: 65535
  validates :author, presence: true
  validates :answer, presence: true
  validates :content, presence: true

  scope :unapproved, -> { where(approved: false) }
end

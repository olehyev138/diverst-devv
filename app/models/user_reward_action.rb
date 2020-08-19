class UserRewardAction < BaseClass
  enum operation: [:add, :del]

  belongs_to :user
  belongs_to :reward_action
  belongs_to :initiative
  belongs_to :initiative_comment
  belongs_to :group_message
  belongs_to :group_message_comment
  belongs_to :news_link
  belongs_to :news_link_comment
  belongs_to :social_link
  belongs_to :answer_comment
  belongs_to :answer_upvote
  belongs_to :answer
  belongs_to :poll_response

  validates :user, presence: true
  validates :reward_action, presence: true
  validates :operation, presence: true
  validates :points, numericality: { only_integer: true }, presence: true
end

class AnswerUpvote < BaseClass
  belongs_to :answer, counter_cache: :upvote_count
  belongs_to :user, foreign_key: 'author_id'

  has_many :user_reward_actions
end

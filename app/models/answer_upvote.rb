class AnswerUpvote < ActiveRecord::Base
  belongs_to :answer, counter_cache: :upvote_count
  belongs_to :user, foreign_key: 'author_id'
end

class AnswerUpvote < ActiveRecord::Base
  belongs_to :answer
  belongs_to :user, foreign_key: 'author_id'
end

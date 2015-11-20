class AnswerUpvote < ActiveRecord::Base
  belongs_to :answer
  belongs_to :employee, foreign_key: "author_id"
end

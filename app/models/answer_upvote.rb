class AnswerUpvote < ActiveRecord::Base
  belongs_to :answer
  belongs_to :employee
end

class Answer < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :question, inverse_of: :answers
  belongs_to :author, class_name: "Employee", inverse_of: :answers

  has_many :answer_upvotes
  has_many :votes, class_name: "AnswerUpvote"
  has_many :comments, class_name: "AnswerComment"
end

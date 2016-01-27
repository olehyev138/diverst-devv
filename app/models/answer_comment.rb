class AnswerComment < ActiveRecord::Base
  belongs_to :author, class_name: 'Employee', inverse_of: :answers
  belongs_to :answer, inverse_of: :comments
end

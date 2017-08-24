class AnswerExpense < ActiveRecord::Base
  belongs_to :answer
  belongs_to :expense
end
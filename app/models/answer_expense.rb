class AnswerExpense < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :expense
end
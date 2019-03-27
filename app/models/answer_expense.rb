class AnswerExpense < BaseClass
  belongs_to :answer
  belongs_to :expense

  validates :answer, presence: true
  validates :expense, presence: true
end

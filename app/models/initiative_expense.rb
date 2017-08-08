class InitiativeExpense < ActiveRecord::Base
  belongs_to :initiative
  belongs_to :owner, class_name: "User"

  validates :initiative, presence: true
  validates :owner, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end

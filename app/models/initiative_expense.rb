class InitiativeExpense < ApplicationRecord
  belongs_to :initiative
  belongs_to :owner, class_name: 'User'
  has_one :annual_budget, through: :initiative

  validates_length_of :description, maximum: 191
  validates :initiative, presence: true
  validates :annual_budget, presence: true
  validates :owner, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end

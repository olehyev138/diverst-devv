class InitiativeExpense < ApplicationRecord
  belongs_to :initiative
  belongs_to :owner, class_name: 'User'
  has_one :annual_budget, through: :initiative

  validates_length_of :description, maximum: 191
  validates :initiative, presence: true
  validates :annual_budget, presence: true
  validates :owner, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_save :update_annual_budget
  after_destroy :update_annual_budget


  private

  def update_annual_budget
    group = initiative.owner_group
    annual_budget = AnnualBudget.find_or_create_by(closed: false, group_id: group.id)
    return if annual_budget.nil?

    leftover_of_annual_budget = (group.annual_budget - group.annual_budget_approved) + group.annual_budget_available
    group.update(leftover_money: leftover_of_annual_budget)
    annual_budget.update(amount: group.annual_budget, available: group.annual_budget_available,
                         leftover_money: group.annual_budget_remaining, expenses: group.annual_budget_spent,
                         approved: group.annual_budget_approved)
  end
end

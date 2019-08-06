class InitiativeExpense < ApplicationRecord
  belongs_to :initiative
  belongs_to :owner, class_name: 'User'
  belongs_to :annual_budget

  validates_length_of :description, maximum: 191
  validates :initiative, presence: true
  validates :annual_budget_id, presence: true
  validates :owner, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_save :update_annual_budget
  after_destroy :update_annual_budget


  private

  def update_annual_budget
    group = initiative.owner_group
    annual_budget = AnnualBudget.find_or_create_by(closed: false, group_id: group.id)
    return if annual_budget.nil?

    leftover_of_annual_budget = (group.annual_budget - group.approved_budget) + group.available_budget
    group.update(leftover_money: leftover_of_annual_budget)
    annual_budget.update(amount: group.annual_budget, available_budget: group.available_budget,
                         leftover_money: group.leftover_money, expenses: group.spent_budget,
                         approved_budget: group.approved_budget)
  end
end

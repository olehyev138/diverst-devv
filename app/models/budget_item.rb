class BudgetItem < ApplicationRecord
  include BudgetItem::Actions
  LEFTOVER_BUDGET_ITEM_ID = -1

  belongs_to :budget, counter_cache: true
  has_one :annual_budget, through: :budget
  has_one :group, through: :annual_budget

  has_many :initiatives
  has_many :initiatives_expenses, through: :initiatives, source: :expenses

  validates_length_of :title, maximum: 191
  validates_presence_of :budget
  validates :title, presence: true, length: { minimum: 2 }
  validates :estimated_amount, numericality: { less_than_or_equal_to: 999999, message: 'number of digits must not exceed 6' }

  scope :available, -> { joins(:budget).where(is_done: false).where('budgets.is_approved = TRUE') }
  scope :allocated, -> { where(is_done: true) }
  scope :approved, -> { joins(:budget).where(budgets: { is_approved: true }) }
  scope :not_approved, -> { joins(:budget).where(budgets: { is_approved: false }) }
  scope :pending, -> { joins(:budget).where(budgets: { is_approved: nil }) }
  scope :private_scope, -> (user_id = nil) { joins(:budget).where('is_private = FALSE OR budgets.requester_id = ?', user_id) }

  delegate :finalized, to: :initiatives, prefix: true
  delegate :finalized, to: :initiatives_expenses, prefix: 'expenses'
  delegate :active, to: :initiatives, prefix: true
  delegate :active, to: :initiatives_expenses, prefix: 'expenses'

  def close!
    if is_done?
      errors.add(:base, 'Budget Item is already closed')
      return false
    end

    if initiatives.active.any?
      errors.add(:base, 'There are still events using this budget item')
      return false
    end

    self.update(is_done: true, estimated_amount: reserved)
  end

  def available_for_event(event)
    event_offset = event.present? && event.budget_item_id == id ? event.estimated_funding : 0
    available_amount + event_offset
  end

  def title_with_amount(event = nil)
    "#{title} ($%.2f)" % available_for_event(event)
  end

  def expenses
    initiatives_expenses.sum('amount')
  end

  def reserved
    initiatives_active.sum('estimated_funding') + finalized_expenditure
  end

  def available_amount
    return 0 if budget.blank?
    return 0 if is_done || !(budget.is_approved?)

    estimated_amount - reserved
  end

  def unspent
    estimated_amount - expenses
  end

  def finalized_expenditure
    expenses_finalized.sum('amount')
  end

  def approve!
    self.update(deprecated_available_amount: estimated_amount)
  end
end

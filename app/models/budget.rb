class Budget < ApplicationRecord
  include PublicActivity::Common
  # include Budget::Actions

  belongs_to :annual_budget
  belongs_to :approver, class_name: 'User', foreign_key: 'approver_id'
  belongs_to :requester, class_name: 'User', foreign_key: 'requester_id'
  has_one :group, through: :annual_budget

  has_many :checklists, dependent: :destroy
  has_many :budget_items, dependent: :destroy
  accepts_nested_attributes_for :budget_items, reject_if: :all_blank, allow_destroy: true

  scope :approved, -> { where(is_approved: true) }
  scope :not_approved, -> { where(is_approved: false) }
  scope :pending, -> { where(is_approved: nil) }

  # scope :with_available_funds, -> { where('available_amount > 0')}

  after_save :send_email_notification
  after_destroy :update_annual_budget

  validates_length_of :decline_reason, maximum: 191
  validates_length_of :comments, maximum: 65535
  validates_length_of :description, maximum: 65535

  def requested_amount
    budget_items.sum(:estimated_amount)
  end

  def available_amount
    return 0 unless is_approved

    budget_items.available.sum(:available_amount)
  end

  def status_title
    return 'Pending' if is_approved.nil?

    if is_approved
      'Approved'
    else
      'Declined'
    end
  end

  def self.pre_approved_events(group, user = nil)
    related_budgets = self.joins(:group)
                          .where(annual_budgets: {group: group})
                          .approved
                          .includes(:budget_items)

    budget_items = related_budgets.map { |b| b.budget_items }

    flattened_items = budget_items.flatten.select { |bi| bi.is_done == false }

    if user.present?
      flattened_items = flattened_items.select do |bi|
        if bi.is_private?
          bi.budget.requester == user
        else
          true
        end
      end
    end

    flattened_items
  end

  def self.pre_approved_events_for_select(group, user = nil, initiative = nil)
    budget_items = self.pre_approved_events(group, user)

    select_items = budget_items.map do |bi|
      [ bi.title_with_amount, bi.id ]
    end

    if initiative&.persisted?
      return select_items if initiative&.current_expences_sum.to_f > initiative&.estimated_funding.to_f
    end

    select_items << [ group.title_with_leftover_amount, BudgetItem::LEFTOVER_BUDGET_ITEM_ID ]
  end

  private

  def update_annual_budget
    annual_budget = AnnualBudget.find_or_create_by(closed: false, group_id: group.id)
    return if annual_budget.nil?

    leftover_of_annual_budget = ((group.annual_budget || annual_budget.amount) - group.approved_budget) + group.available_budget
    group.update(leftover_money: leftover_of_annual_budget, annual_budget: annual_budget.amount)
    annual_budget.update(amount: group.annual_budget, available_budget: group.available_budget,
                         leftover_money: group.leftover_money, expenses: group.spent_budget,
                         approved_budget: group.approved_budget)
  end

  def send_email_notification
    case is_approved
    when nil # it was just created
      send_approval_request
    when true # it was accepted
      send_approval_notification
    when false # it was declined
      send_denial_notification
    end
  end

  def send_approval_request
    return if approver.blank?

    BudgetMailer.approve_request(self, approver).deliver_later
  end

  def send_approval_notification
    BudgetMailer.budget_approved(self).deliver_later if self.requester
  end

  def send_denial_notification
    BudgetMailer.budget_declined(self).deliver_later if self.requester
  end
end

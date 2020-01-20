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
                          .where(annual_budgets: { group: group })
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

  def approve(approver)
    budget_items.each do |bi|
      bi.approve!
    end
    update(approver: approver, is_approved: true)
    BudgetMailer.budget_approved(self).deliver_later if requester
  end

  def decline(approver)
    update(approver: approver, is_approved: false)
    BudgetMailer.budget_declined(self).deliver_later if requester
  end

  private

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

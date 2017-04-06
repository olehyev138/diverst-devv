class Budget < ActiveRecord::Base
  belongs_to :subject, polymorphic: true
  belongs_to :approver, class_name: "User", foreign_key: "approver_id"
  belongs_to :requester, class_name: "User", foreign_key: "requester_id"

  has_many :checklists, as: :subject
  has_many :budget_items
  accepts_nested_attributes_for :budget_items, reject_if: :all_blank, allow_destroy: true

  validates :subject, presence: true

  scope :approved, -> { where(is_approved: true) }
  scope :not_approved, -> { where(is_approved: false )}
  scope :pending, -> { where(is_approved: nil )}

  #scope :with_available_funds, -> { where('available_amount > 0')}

  after_create :send_approval_request, if: Proc.new { |budget| budget.approver_id.present? }

  def requested_amount
    budget_items.sum(:estimated_amount)
  end

  def available_amount
    return 0 unless is_approved

    budget_items.available.sum(:available_amount)
  end

  def approve!
    budget_items.each do |bi|
      bi.approve!
    end

    self.update(is_approved: true)
  end

  def decline!
    self.update(is_approved: false)
  end

  def status_title
    return 'Pending' if is_approved.nil?

    if is_approved
      'Approved'
    else
      'Declined'
    end
  end

  def self.pre_approved_events(group)
    related_budgets = self.where(subject_id: group.id)
                          .where(subject_type: group.class.to_s)
                          .approved
                          .includes(:budget_items)

    budget_items = related_budgets.map { |b| b.budget_items }

    budget_items.flatten.select { |bi| bi.is_done == false }
  end

  #bTODO test this method
  def self.pre_approved_events_for_select(group)

    budget_items = self.pre_approved_events(group)

    select_items = budget_items.map do |bi|
      [ bi.title_with_amount , bi.id ]
    end

    select_items << [ group.title_with_leftover_amount, BudgetItem::LEFTOVER_BUDGET_ITEM_ID ]
  end

  def send_approval_request
    return unless approver.present?

    BudgetMailer.approve_request(self, approver).deliver_later
  end
end

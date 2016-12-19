class Budget < ActiveRecord::Base
  belongs_to :subject, polymorphic: true

  has_many :checklists, as: :subject

  validates :subject, :requested_amount, presence: true
  validates :requested_amount, numericality: { greater_than: 0 }
  validates :agreed_amount, numericality: { less_than_or_equal_to: :requested_amount }, allow_nil: true
  validates :available_amount, numericality: { less_than_or_equal_to: :agreed_amount }, allow_nil: true

  has_many :budget_items
  accepts_nested_attributes_for :budget_items, reject_if: :all_blank, allow_destroy: true

  scope :approved, -> { where(is_approved: true) }
  scope :not_approved, -> { where(is_approved: false )}
  scope :pending, -> { where(is_approved: nil )}

  scope :with_available_funds, -> { where('available_amount > 0')}

  def requested_amount
    budget_items.sum(:estimated_price)
  end

  def approve!(amount = nil)
    if amount.nil? # approve full
      self.agreed_amount = self.requested_amount
    else
      # approve partial amount
      self.agreed_amount = amount
    end

    self.available_amount = self.agreed_amount
    self.is_approved = true

    self.save
  end

  def decline!
    self.update(is_approved: false)
  end

  def status_title
    return 'Pending' if is_approved.nil?

    if is_approved
      if requested_amount == agreed_amount
        'Fully Approved'
      else
        'Partially Approved'
      end
    else
      'Rejected'
    end
  end

  def self.pre_approved_events(group)
    related_budgets = self.where(subject_id: group.id)
                          .where(subject_type: group.class.to_s)
                          .approved
                          .with_available_funds
                          .includes(:checklist_items)

    checklist_items = related_budgets.map { |b| b.checklist_items }

    checklist_items.flatten
  end

  def self.pre_approved_events_for_select(group)

    checklist_items = self.pre_approved_events(group)

    checklist_items.map do |ci|
      title = "#{ci.title} (max: $#{ci.container.available_amount})"

      [ title , ci.container_id ]
    end
  end
end

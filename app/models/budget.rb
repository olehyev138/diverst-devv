class Budget < ActiveRecord::Base
  belongs_to :subject, polymorphic: true

  has_many :checklists, as: :subject

  validates :subject, presence: true

  has_many :budget_items
  accepts_nested_attributes_for :budget_items, reject_if: :all_blank, allow_destroy: true

  scope :approved, -> { where(is_approved: true) }
  scope :not_approved, -> { where(is_approved: false )}
  scope :pending, -> { where(is_approved: nil )}

  #scope :with_available_funds, -> { where('available_amount > 0')}

  def requested_amount
    budget_items.sum(:estimated_amount)
  end

  def available_amount
    return 0 unless is_approved

    budget_items.available.sum(:available_amount)
  end

  def approve!
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

    budget_items.map do |bi|
      [ bi.title_with_amount , bi.id ]
    end
  end
end

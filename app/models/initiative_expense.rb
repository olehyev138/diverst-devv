class InitiativeExpense < ApplicationRecord
  belongs_to :initiative
  belongs_to :owner, class_name: 'User'
  has_one :annual_budget, through: :initiative
  has_one :group, through: :annual_budget
  has_one :enterprise, through: :group

  validates_length_of :description, maximum: 191
  validates :initiative, presence: true
  validates :annual_budget, presence: true
  validates :owner, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate -> { initiative_is_not_finalized }

  scope :finalized, -> { joins(:initiative).where(initiatives: { finished_expenses: true }) }
  scope :active, -> { joins(:initiative).where(initiatives: { finished_expenses: false }) }

  def initiative_is_not_finalized
    if initiative.blank? || initiative.finish_expenses
      errors.add(:initiative, "Can't #{new_record? ? 'add' : 'edit'} an expense for a closed initiative")
    end
  end
end

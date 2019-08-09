class BudgetItem < BaseClass
  LEFTOVER_BUDGET_ITEM_ID = -1
  belongs_to :budget, counter_cache: true
  has_many :initiatives

  validates_length_of :title, maximum: 191
  validates :title, presence: true, length: { minimum: 2 }
  validates :estimated_amount, numericality: { less_than_or_equal_to: 999999, message: 'number of digits must not exceed 6' }
  validates :available_amount, numericality: { less_than_or_equal_to: :estimated_amount },
                               allow_nil: true, unless: -> { estimated_amount.blank? }

  scope :available, -> { where(is_done: false) }
  scope :allocated, -> { where(is_done: true) }

  def title_with_amount
    "#{title} ($#{available_amount})"
  end

  def available_amount
    return 0 if is_done

    read_attribute(:available_amount)
  end

  def approve!
    self.update(available_amount: estimated_amount)
  end
end

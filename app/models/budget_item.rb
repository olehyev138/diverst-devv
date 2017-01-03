class BudgetItem < ActiveRecord::Base
  belongs_to :budget
  has_many :initiatives

  validates :title, presence: true, length: { minimum: 2 }
  validates :estimated_amount, numericality: true
  validates :available_amount, numericality: { less_than_or_equal_to: :estimated_amount}, allow_nil: true

  scope :available, -> { where(is_done: false)}
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

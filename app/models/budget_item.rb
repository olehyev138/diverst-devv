class BudgetItem < ActiveRecord::Base
  belongs_to :budget
  has_many :initiatives

  validates :title, presence: true, length: { minimum: 2 }
  validates :estimated_amount, numericality: true
  validates :available_amount, numericality: { less_than_or_equal_to: :estimated_amount}

  scope :available, -> { where(is_done: false)}
  scope :allocated, -> { where(is_done: true) }

  def title_with_amount
    "#{title} (#{estimated_amount})"
  end

  #bTODO after approving budget set available_amount to estimated amount
end

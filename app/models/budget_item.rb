class BudgetItem < ActiveRecord::Base
  belongs_to :budget
  validates :title, presence: true, length: { minimum: 2 }
  validates :estimated_price, numericality: true
end

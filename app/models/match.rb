class Match < ActiveRecord::Base
  belongs_to :user1, class_name: "Employee"
  belongs_to :user2, class_name: "Employee"

  accepts_nested_attributes_for :user1, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :user2, reject_if: :all_blank, allow_destroy: true

  scope :has_employee, ->(employee) { where('user1_id = ? OR user2_id = ?', employee.id, employee.id) }
  scope :between, ->(employee1, employee2) { has_employee(employee1).has_employee(employee2) }

  before_create :update_score

  def update_score
    self.score = self.user1.match_score_with(self.user2)
    self.score_calculated_at = Time.now
  end

  # Returns the other employee or nil if the passed employee isn't in this match
  def other(employee)
    return user2 if user1 == employee
    return user1 if user2 == employee
    nil
  end
end

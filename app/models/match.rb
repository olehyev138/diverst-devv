class Match < ActiveRecord::Base
  @@status = {
    unswiped: 0,
    accepted: 1,
    rejected: 2
  }.freeze

  belongs_to :user1, class_name: "Employee"
  belongs_to :user2, class_name: "Employee"

  accepts_nested_attributes_for :user1, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :user2, reject_if: :all_blank, allow_destroy: true

  scope :not_archived, -> { where(archived: false) }
  scope :has_employee, ->(employee) { where('user1_id = ? OR user2_id = ?', employee.id, employee.id) }
  scope :between, ->(employee1, employee2) { has_employee(employee1).has_employee(employee2) }
  # An active match is a match that should still be shown in the swipes screen. It hasn't been rejected by anybody and hasn't been swiped yet
  scope :active_for, ->(employee) { where('user1_id = ? AND user1_status = ? AND user2_status <> ? OR user2_id = ? AND user2_status = ? AND user1_status <> ?', employee.id, status[:unswiped], status[:rejected], employee.id, status[:unswiped], status[:rejected]) }
  scope :accepted, -> { where('user2_status = ? AND user1_status = ?', @@status[:accepted], @@status[:accepted]) }

  before_create :update_score

  def update_score
    self.score = self.user1.match_score_with(self.user2)
    self.score_calculated_at = Time.zone.now
  end

  def set_status(employee:, status:)
    if employee.id == self.user1_id
      self.user1_status = status
    elsif employee.id == self.user2_id
      self.user2_status = status
    else
      raise Exception.new("Employee not part of match")
    end

    self.save
  end

  def status_for(employee)
    if employee.id == self.user1_id
      self.user1_status
    elsif employee.id == self.user2_id
      self.user2_status
    else
      raise Exception.new("Employee not part of match")
    end
  end

  # Returns the other employee
  def other(employee)
    return user2 if user1_id == employee.id
    return user1 if user2_id == employee.id
    raise Exception.new("Employee not part of match")
  end

  def both_accepted?
    user1_status == @@status[:accepted] && user2_status == @@status[:accepted]
  end

  def self.status
    @@status
  end
end
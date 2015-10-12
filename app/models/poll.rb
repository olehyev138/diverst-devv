class Poll < ActiveRecord::Base
  has_many :fields, inverse_of: :poll
  has_many :responses, class_name: "PollResponse", inverse_of: :poll
  has_and_belongs_to_many :segments, inverse_of: :polls
  has_and_belongs_to_many :groups, inverse_of: :polls
  belongs_to :enterprise, inverse_of: :polls

  after_create :send_invitation_emails

  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true

  # Returns the list of employees targeted by the poll
  def employees
    Employee
    .joins(:groups, :segments)
    .where(
      "groups.id" => self.groups.ids,
      "segments.id" => self.segments.ids
    )
  end

  # Checks if the specified employee is targeted by the poll
  def targets_employee?(employee)
    employees.where(id => employee.id).count > 0
  end

  def send_invitation_emails
    self.employees.each do |employee|
      PollMailer.delay.invitation(self, employee)
    end
  end
end

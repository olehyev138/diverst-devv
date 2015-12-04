class Poll < ActiveRecord::Base
  has_many :fields, as: :container
  has_many :responses, class_name: "PollResponse", inverse_of: :poll
  has_many :graphs, as: :collection
  has_and_belongs_to_many :segments, inverse_of: :polls
  has_and_belongs_to_many :groups, inverse_of: :polls
  belongs_to :enterprise, inverse_of: :polls

  after_create :send_invitation_emails
  after_create :create_default_graphs

  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true

  # Returns the list of employees who have answered the poll
  def graphs_population
    Employee.answered_poll(self)
  end

  # Returns the list of employees who meet the participation criteria for the poll
  def targeted_employees
    target = Employee.all

    if !segments.empty?
      target = target.for_segments(segments)
    end

    if !groups.empty?
      target = target.for_groups(groups)
    end

    target
  end

  # Defines which fields will be usable when creating graphs
  def graphable_fields(admin)
    admin.enterprise.fields + self.fields
  end

  protected

  def send_invitation_emails
    self.targeted_employees.each do |employee|
      PollMailer.delay.invitation(self, employee)
    end
  end

  # Creates one graph per field when the poll is created
  def create_default_graphs
    self.fields.each do |field|
      self.graphs.create(field: field) if field.graphable?
    end
  end
end

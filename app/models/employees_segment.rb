class EmployeesSegment < ActiveRecord::Base
  belongs_to :employee
  belongs_to :segment
end

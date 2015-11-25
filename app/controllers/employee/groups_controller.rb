class Employee::GroupsController < ApplicationController
  before_action :authenticate_employee!

  layout "employee"

  def index
    @groups = current_employee.employee_groups.order(created_at: :desc).map(&:group)
  end
end

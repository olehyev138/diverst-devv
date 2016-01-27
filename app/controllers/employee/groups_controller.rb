class Employee::GroupsController < ApplicationController
  before_action :authenticate_employee!

  layout 'employee'

  def index
    @groups = current_employee.enterprise.groups
  end

  def join
    @group = current_employee.enterprise.groups.find(params[:id])
    return if @group.members.include? current_employee
    @group.members << current_employee
    @group.save
  end
end

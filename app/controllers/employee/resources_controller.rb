class Employee::ResourcesController < ApplicationController
  include IsResources

  before_action :authenticate_employee!

  layout 'employee'

  protected

  def set_container
    @group = @container = current_employee.enterprise
  end
end

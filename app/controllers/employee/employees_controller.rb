class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_employee, only: [:edit, :update, :destroy, :show]

  layout "employee"

  def update
    redirect_to [:employee, @employee] if @employee != current_user && !current_user.is_a?(Admin)

    if @employee.update_attributes(employee_params)
      redirect_to [:employee, @employee]
    else
      render :edit
    end
  end

  protected

  def set_employee
    @employee = current_admin.enterprise.employees.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:email)
  end
end

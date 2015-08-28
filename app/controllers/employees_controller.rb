class EmployeesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_employee, only: [:edit, :update, :destroy, :show]

  def index
    @employees = current_admin.enterprise.employees

    respond_to do |format|
      format.html
      format.json { render json: @employees }
    end
  end

  def update
    @employee.assign_attributes(employee_params)
    @employee.merge_info(params['custom-fields'])

    if @employee.save
      redirect_to @employee
    else
      render :edit
    end
  end

  def destroy
    @employee.destroy
    redirect_to :back
  end

  protected

  def set_employee
    @employee = current_admin.enterprise.employees.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:email)
  end
end

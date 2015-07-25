class EmployeesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @employees = current_admin.enterprise.employees

    respond_to do |format|
      format.html
      format.json { render json: @employees }
    end
  end

  def update
    if @employee.update(employee_params)
      redirect_to @employee.characters[0]
    else
      render :edit
    end
  end

  protected

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def set_employee_params
    params.require(:set_employee).permit(:jouPrenom, :jouNom, :email)
  end
end

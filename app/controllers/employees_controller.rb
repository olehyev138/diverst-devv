class EmployeesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_employee, only: [:edit, :update, :destroy, :show]

  layout "global_settings"

  def index
    @employees = current_admin.enterprise.employees.page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: EmployeeDatatable.new(view_context) }
    end
  end

  def update
    @employee.assign_attributes(employee_params)
    @employee.info.merge(fields: @employee.enterprise.fields, form_data: params['custom-fields'])

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

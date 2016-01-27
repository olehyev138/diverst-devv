class EmployeesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_employee, only: [:edit, :update, :destroy, :show]

  layout 'global_settings'

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

  def sample_csv
    send_data current_admin.enterprise.employees_csv(5), filename: 'diverst_import.csv'
  end

  def parse_csv
    @table = CSV.table params[:file].tempfile
    @failed_rows = []
    @successful_rows = []

    @table.each_with_index do |row, row_index|
      employee = Employee.from_csv_row(row, enterprise: current_admin.enterprise)

      if employee
        if employee.save
          employee.invite!(current_admin)
          @successful_rows << row
        else
          # ActiveRecord validation failed on employee
          @failed_rows << {
            row: row,
            row_index: row_index + 1,
            error: employee.errors.full_messages.join(', ')
          }
        end
      else
        # Employee.from_csv_row returned nil
        @failed_rows << {
          row: row,
          row_index: row_index + 1,
          error: 'Missing required information'
        }
      end
    end
  end

  def export_csv
    send_data current_admin.enterprise.employees_csv(nil), filename: 'diverst_employees.csv'
  end

  protected

  def set_employee
    @employee = current_admin.enterprise.employees.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:email)
  end
end

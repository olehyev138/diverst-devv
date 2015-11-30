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

  def sample_csv
    csv_string = CSV.generate do |csv|
      csv << ["First name", "Last name", "Email"].concat(current_admin.enterprise.fields.map(&:title))

      current_admin.enterprise.employees.order(created_at: :desc).limit(5).each do |employee|
        employee_columns = [employee.first_name, employee.last_name, employee.email]

        current_admin.enterprise.fields.each do |field|
          employee_columns << field.csv_value(employee.info[field])
        end

        csv << employee_columns
      end
    end

    send_data csv_string, filename: "diverst_import.csv"
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
          error: "Missing required information"
        }
      end
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

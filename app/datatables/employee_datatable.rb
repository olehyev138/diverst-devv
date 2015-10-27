class EmployeeDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :employee_path

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['Employee.first_name', 'Employee.last_name', 'Employee.email', 'Employee.first_name']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['Employee.first_name', 'Employee.last_name', 'Employee.email']
  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        record.first_name,
        record.last_name,
        record.email,
        "#{link_to("Details", employee_path(record))} - #{link_to("Remove", employee_path(record), class: 'error', method: :delete)}"
      ]
    end
  end

  def get_raw_records
    # insert query here
    Employee.invitation_accepted
  end

  # ==== Insert 'presenter'-like methods below if necessary
end

class UserDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :user_path

  def initialize(view_context, users)
    super(view_context)
    @users = users
  end

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['User.first_name', 'User.last_name', 'User.email', 'User.first_name']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['User.first_name', 'User.last_name', 'User.email']
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
        "#{link_to('Details', user_path(record))} - #{link_to('Remove', user_path(record), class: 'error', method: :delete)}"
      ]
    end
  end

  def get_raw_records
    # insert query here
    @users
  end

  # ==== Insert 'presenter'-like methods below if necessary
end

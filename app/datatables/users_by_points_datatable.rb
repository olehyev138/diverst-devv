class UsersByPointsDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :show_usage_user_path

  def initialize(view_context, users, read_only: false)
    super(view_context)
    @users = users
  end

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(User.first_name User.last_name User.email User.points)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(User.first_name User.last_name User.email)
  end

  private

  def data
    records.map do |record|
      [
        record.first_name,
        record.last_name,
        record.email,
        record.points
      ]
    end
  end

  def get_raw_records
    @users
  end

  # ==== Insert 'presenter'-like methods below if necessary
end

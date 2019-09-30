class UserMentorGenericListDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :user_mentorship_metrics_mentorship_path

  def initialize(view_context, user_id, mentors)
    super(view_context)
    @user_id = user_id
    @mentors = mentors
  end

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(User.first_name User.last_name User.email)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= @sortable_columns ||= %w(User.first_name User.last_name User.email)
  end

  private

  def data
    records.map do |record|
      [
        record.first_name,
        record.last_name,
        record.email,
        link_to('Details', user_mentorship_metrics_mentorship_path(record.id))
      ]
    end
  end

  def get_raw_records
    @mentors
  end
end

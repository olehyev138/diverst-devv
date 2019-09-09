class UserMentorshipStatsDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :user_mentorship_metrics_mentorship_path
  def_delegator :@view, :user_user_path

  def initialize(view_context, has_value: true)
    super(view_context)
    @has_value = has_value
  end

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(UserWithMentorCount.first_name UserWithMentorCount.last_name UserWithMentorCount.email UserWithMentorCount.number_of_mentees UserWithMentorCount.number_of_mentors)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w( UserWithMentorCount.first_name UserWithMentorCount.last_name UserWithMentorCount.email)
  end

  private

  def data
    if @has_value
      records.map do |record|
        [
          link_to(record.first_name, user_user_path(record.user_id), target: :_blank),
          record.last_name,
          record.email,
          record.number_of_mentees,
          record.number_of_mentors,
          link_to('Details', user_mentorship_metrics_mentorship_path(record.user_id), target: :_blank),
          # link_to('Export CSV', user_mentorship_metrics_mentorship_path(record.user_id, format: :csv))
        ]
      end
    else
      records.map do |record|
        [
          link_to(record.first_name, user_user_path(record.user_id), target: :_blank),
          record.last_name,
          record.email
        ]
      end
    end
  end

  def get_raw_records
    if @has_value
      UserWithMentorCount.where('number_of_mentees > 0 OR number_of_mentors > 0')
    else
      UserWithMentorCount.where('number_of_mentees <= 0 AND number_of_mentors <= 0')
    end
  end
end

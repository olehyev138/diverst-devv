class UserMentorshipStatsDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :user_mentorship_metrics_mentorship_path
  def_delegator :@view, :user_user_path

  def initialize(view_context, type: 'has_either')
    super(view_context)
    @type = type
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
    case @type
    when 'has_either'
      records.map do |record|
        [
          link_to(record.first_name, user_user_path(record.user_id), target: :_blank),
          record.last_name,
          record.email,
          record.number_of_mentees,
          record.number_of_mentors,
          link_to('Details', user_mentorship_metrics_mentorship_path(record.user_id), target: :_blank),
        ]
      end
    when /^no/
      records.map do |record|
        [
          link_to(record.first_name, user_user_path(record.user_id), target: :_blank),
          record.last_name,
          link_to('Details', user_mentorship_metrics_mentorship_path(record.user_id), target: :_blank)
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
    case @type
    when 'has_either'
      UserWithMentorCount.where('number_of_mentees > 0 OR number_of_mentors > 0')
    when 'no_mentee'
      UserWithMentorCount.where('number_of_mentees <= 0 AND number_of_mentors > 0')
    when 'no_mentor'
      UserWithMentorCount.where('number_of_mentors <= 0 AND number_of_mentees > 0')
    when 'has_neither'
      UserWithMentorCount.where('number_of_mentors <= 0 AND number_of_mentees <= 0')
    end
  end
end

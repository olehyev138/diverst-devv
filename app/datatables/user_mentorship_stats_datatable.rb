class UserMentorshipStatsDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :user_mentorship_metrics_mentorship_path
  def_delegator :@view, :user_user_path
  def_delegator :@view, :current_user

  def initialize(view_context, type: 'has_either')
    super(view_context)
    @enterprise_id = current_user.enterprise.id
    @type = type
  end

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(User.first_name User.last_name User.email User.mentees_count User.mentors_count)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w( User.first_name User.last_name User.email)
  end

  private

  def data
    case @type
    when 'has_either'
      records.map do |record|
        [
          link_to(record.first_name, user_user_path(record.id), target: :_blank),
          record.last_name,
          record.email,
          record.mentees_count,
          record.mentors_count,
          link_to('Details', user_mentorship_metrics_mentorship_path(record.id), target: :_blank),
        ]
      end
    when /^no/
      records.map do |record|
        [
          link_to(record.first_name, user_user_path(record.id), target: :_blank),
          record.last_name,
          link_to('Details', user_mentorship_metrics_mentorship_path(record.id), target: :_blank)
        ]
      end
    else
      records.map do |record|
        [
          link_to(record.first_name, user_user_path(record.id), target: :_blank),
          record.last_name,
          record.email
        ]
      end
    end
  end

  def get_raw_records
    users = User.where(enterprise_id: @enterprise_id)
    case @type
    when 'has_either'
      users.where('mentees_count > 0 OR mentors_count > 0')
    when 'no_mentee'
      users.where('mentees_count <= 0 AND mentors_count > 0')
    when 'no_mentor'
      users.where('mentors_count <= 0 AND mentees_count > 0')
    when 'has_neither'
      users.where('mentors_count <= 0 AND mentees_count <= 0')
    end
  end
end

class UserMenteeListDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :user_mentorship_metrics_mentorship_path

  def initialize(view_context, user_id)
    super(view_context)
    @user_id = user_id
  end

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(UserMentorPair.mentee_first_name UserMentorPair.mentee_last_name UserMentorPair.mentee_email)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= @sortable_columns ||= %w(UserMentorPair.mentee_first_name UserMentorPair.mentee_last_name UserMentorPair.mentee_email)
  end

  private

  def data
    records.map do |record|
      [
        record.mentee_first_name,
        record.mentee_last_name,
        record.mentee_email,
        link_to('Details', user_mentorship_metrics_mentorship_path(record.mentee_id), target: :_blank)
      ]
    end
  end

  def get_raw_records
    UserMentorPair.where(mentor_id: @user_id)
  end

  # ==== Insert 'presenter'-like methods below if necessary
end

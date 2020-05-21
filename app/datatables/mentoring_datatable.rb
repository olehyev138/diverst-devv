class MentoringDatatable < AjaxDatatablesRails::Base
  include ERB::Util

  def_delegator :@view, :link_to
  def_delegator :@view, :new_mentoring_request_path
  def_delegator :@view, :user_mentorship_path

  def initialize(view_context, users, current_user, mentors = true)
    super(view_context)
    @user = current_user
    @users = users
    @mentors = mentors
  end

  def sortable_columns
    @sortable_columns ||= ['User.first_name', 'User.email']
  end

  def searchable_columns
    @searchable_columns ||= []
  end

  private

  def data
    records.map do |record|
      if @mentors
        [
          "#{link_to record.name, user_mentorship_path(id: record.id) }",
          html_escape(record.email),
          record.mentoring_interests.pluck(:name).join(', '),
          "#{link_to('Request', new_mentoring_request_path(sender_id: @user.id, receiver_id: record.id, mentoring_type: "mentor"))}",
        ]
      else
        [
          "#{link_to record.name, user_mentorship_path(id: record.id) }",
          html_escape(record.email),
          record.mentoring_interests.pluck(:name).join(', '),
          "#{link_to('Request', new_mentoring_request_path(sender_id: @user.id, receiver_id: record.id, mentoring_type: "mentee"))}"
        ]
      end
    end
  end

  def get_raw_records
    @users
  end

  # ==== Insert 'presenter'-like methods below if necessary
end

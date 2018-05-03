class MentoringDatatable < AjaxDatatablesRails::Base
  include ERB::Util

  def_delegator :@view, :link_to
  def_delegator :@view, :new_mentoring_request_path

  def initialize(view_context, users, current_user)
    super(view_context)
    @user = current_user
    @users = users
  end

  def sortable_columns
    @sortable_columns ||= ['User.first_name', 'User.last_name', 'User.email']
  end

  def searchable_columns
    @searchable_columns ||= ['User.first_name', 'User.last_name', 'User.email']
  end

  private

  def data
    records.map do |record|
      [
        html_escape(record.first_name),
        html_escape(record.last_name),
        html_escape(record.email),
        "#{link_to('Request', new_mentoring_request_path(:sender_id => record.id, :receiver_id => @user.id) )}"
      ]
    end
  end

  def get_raw_records
    @users
  end

  # ==== Insert 'presenter'-like methods below if necessary
end

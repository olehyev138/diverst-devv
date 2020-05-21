class SegmentMemberDatatable < AjaxDatatablesRails::Base
  include ERB::Util

  def_delegator :@view, :link_to
  def_delegator :@view, :user_path

  def initialize(view_context, users)
    super(view_context)
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
        html_escape(record.first_name + ' ' + record.last_name),
        html_escape(record.email),
        "#{link_to('Details', user_path(record))}"
      ]
    end
  end

  def get_raw_records
    @users
  end

  # ==== Insert 'presenter'-like methods below if necessary
end

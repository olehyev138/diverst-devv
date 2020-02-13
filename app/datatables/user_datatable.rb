class UserDatatable < AjaxDatatablesRails::Base
  include ERB::Util

  def_delegator :@view, :link_to
  def_delegator :@view, :user_path

  def initialize(view_context, users, read_only: false)
    super(view_context)
    @users = users
    @user = view_context.current_user
    @read_only = read_only
  end

  def sortable_columns
    @sortable_columns ||= %w(User.first_name User.last_name User.email)
  end

  def searchable_columns
    @searchable_columns ||= %w(User.first_name User.last_name User.email)
  end

  private

  def data
    records.map do |record|
      if UserPolicy.new(@user, record).update? && !@read_only
        [
          record.id,
          html_escape(record.first_name),
          html_escape(record.last_name),
          html_escape(record.email),
          "#{link_to('Details', user_path(record))} - \
          #{link_to('Remove', user_path(record), class: 'error', data: { confirm: "Are you sure?" }, method: :delete) if record != @user}"
        ]
      else
        [
          record.id,
          html_escape(record.first_name),
          html_escape(record.last_name),
          html_escape(record.email),
          "#{link_to('Details', user_path(record))}"
        ]
      end
    end
  end

  def get_raw_records
    @users
  end

  # ==== Insert 'presenter'-like methods below if necessary
end

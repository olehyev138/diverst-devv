class InvitedUserDatatable < AjaxDatatablesRails::Base
  include ERB::Util

  def_delegator :@view, :link_to
  def_delegator :@view, :user_path
  def_delegator :@view, :resend_invitation_user_path

  def initialize(view_context, users)
    super(view_context)
    @users = users
    @user = view_context.current_user
  end

  def sortable_columns
    @sortable_columns ||= ['User.email']
  end

  def searchable_columns
    @searchable_columns ||= ['User.email']
  end

  private

  def data
    records.map do |record|
      if UserPolicy.new(@user, record).update?
        [
          html_escape(record.email),
          "#{link_to "Re-send invitation", resend_invitation_user_path(record), method: :put, class: "primary", data: { confirm: "Are you sure?" }}",
          "#{link_to "Revoke invitation", user_path(record), method: :delete, class: "error", data: { confirm: "Are you sure?" }}"
        ]
      else
        [
          html_escape(record.email), '', ''
        ]
      end
    end
  end

  def get_raw_records
    @users
  end

  # ==== Insert 'presenter'-like methods below if necessary
end

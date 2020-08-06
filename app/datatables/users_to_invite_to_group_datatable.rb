class UsersToInviteToGroupDatatable < AjaxDatatablesRails::Base
  include ERB::Util

  def_delegator :@view, :link_to
  def_delegator :@view, :invite_users_to_join_group_path

  def initialize(view_context, group, users, read_only: false)
    super(view_context)
    @users = users
    @user = view_context.current_user
    @group = group
    @read_only = read_only
  end

  def sortable_columns
    @sortable_columns ||= %w(User.first_name User.last_name User.email)
  end

  def searchable_columns
    @searchable_columns ||= %w(User.first_name User.last_name User.email)
  end

  private

  def link_text(record)
    if @group.user_groups.pluck(:user_id).include?(record.id)
      'Invite Sent!'
    else 
      "Send Invite"
    end
  end

  def send_invite_link(record)
    link_to "#{link_text(record)}", invite_users_to_join_group_path(@group, user_id: record.id),
                           id: record.id, 
                           class: 'send-invite',
                           method: :post, 
                           remote: true
  end

  def data
    records.map do |record|
      [
        html_escape(record.name),
        html_escape(record.email_for_notification),
        "#{send_invite_link(record)}"
      ]
    end
  end

  def get_raw_records
    @users
  end
end

class GroupMemberDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :user_path
  def_delegator :@view, :policy
  def_delegator :@view, :remove_member_group_group_member_path

  def initialize(view_context, group, members)
    super(view_context)
    @group = group
    @members = members
  end

  def sortable_columns
    @sortable_columns ||= ['User.first_name', 'User.active']
  end

  def searchable_columns
    @searchable_columns ||= ['User.first_name', 'User.last_name']
  end

  private

  def data
    records.map do |record|
      show_link = link_to "#{record.name}", user_path(record)
      destroy_link = generate_destroy_link(record)
      [
        show_link,
        record.active ? "Yes" : "No",
        destroy_link
      ]
    end
  end

  def generate_destroy_link(record)
    if policy(@group).manage_members?
      link_to 'Remove From Group', remove_member_group_group_member_path(@group, record),
        method: :delete, class: "error", data: { confirm: "Are you sure?" }
    else
      nil
    end
  end

  def get_raw_records
    @members
  end
end

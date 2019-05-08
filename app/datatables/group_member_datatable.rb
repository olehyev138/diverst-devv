class GroupMemberDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :user_path
  def_delegator :@view, :policy
  def_delegator :@view, :remove_member_group_group_member_path
  def_delegator :@view, :group_group_member_path

  def initialize(view_context, group, members)
    super(view_context)
    @group = group
    @members = members
    @user = view_context.current_user
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
      [
        generate_view_link(record),
        record.active ? 'Yes' : 'No',
        generate_destroy_link(record)
      ]
    end
  end

  def generate_destroy_link(record)
    if GroupMemberPolicy.new(@user, [@group, record]).destroy?
      link_to 'Remove From Group', remove_member_group_group_member_path(@group, record),
              method: :delete, class: 'error', data: { confirm: 'Are you sure?' }
    else
      nil
    end
  end

  def generate_view_link(record)
    if GroupMemberPolicy.new(@user, [@group, record]).update?
      link_to "#{record.name}", group_group_member_path(@group, record)
    else
      "#{record.name}"
    end
  end

  def get_raw_records
    @members
  end
end

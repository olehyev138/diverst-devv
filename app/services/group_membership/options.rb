class GroupMembership::Options
  def initialize(group, user)
    @group = group
    @user = user
  end

  def leave_sub_groups_or_parent_group
    if @group.is_parent_group?
      leave_all_sub_groups
    elsif @group.is_sub_group?
      leave_parent_group
    end
  end


  private

  def leave_all_sub_groups
    sub_group_ids = @group.children.pluck(:id)
    UserGroup.where(user_id: @user.id, group_id: sub_group_ids).destroy_all
  end

  def leave_parent_group
    if @group.parent.present?
      if @group.parent.members.where(id: @user.id).exists?
        UserGroup.find_by(user_id: @user.id, group_id: @group.parent.id).destroy
      end
    end
  end
end

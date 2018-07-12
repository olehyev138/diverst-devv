class GroupMembership::Options
	def initialize(group, user)
		@group = group
		@user = user
	end

	def leave_sub_groups_or_parent_group
		if @group.parent.nil? && @group.children.any?
			leave_all_sub_groups
		else
			leave_parent_group
		end
	end


	private

	def leave_all_sub_groups
		sub_group_ids = @group.children.pluck(:id)
		UserGroup.where(user_id: @user.id, group_id: sub_group_ids).destroy_all
	end

	def leave_parent_group
		if @group.parent.members.include? @user
			UserGroup.find_by(user_id: @user.id, group_id: @group.parent.id).destroy
		end
	end
end
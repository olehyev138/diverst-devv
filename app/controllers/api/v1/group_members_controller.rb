class Api::V1::GroupMembersController < DiverstController
  def add_members
    # authorize [@group], :create?, policy_class: GroupMemberPolicy

    group = Group.find(payload[:group_id])

    payload[:member_ids].each do |user_id|
      user = User.find_by_id(user_id)

      # Only add association if user exists, it belongs to the same enterprise & it hasnt already been created
      if (user) && (user.enterprise == group.enterprise) && !UserGroup.where(user_id: user_id, group_id: group.id).exists?
        begin
          UserGroup.create(group_id: group.id, user_id: user.id, accepted_member: group.pending_users.disabled?)
        rescue => e
          raise BadRequestException.new(e.message)
        end
      else
        # TODO: done properly?
        raise BadRequestException.new('User doesnt exist')
      end

      # if we made it here - were good, serialize group and return status 201
      # render status: 201, json: {}
    end
  end

  def remove_member
    # authorize [@group, @member], :destroy?, policy_class: GroupMemberPolicy

    # TODO: not used

    @group.members.destroy(@member)
  end

  private

  def payload
    params
      .require(:group_member)
      .permit(
        :group_id,
        member_ids: []
      )
  end
end
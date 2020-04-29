class Api::V1::GroupMembersController < DiverstController
  def add_members
    # authorize [@group], :create?, policy_class: GroupMemberPolicy - TODO

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

      # if we made it here - were good, serialize group and return status 204
      track_activity(group)
      render status: 204, json: {}
    end
  end

  def remove_members
    # authorize [@group, @member], :destroy?, policy_class: GroupMemberPolicy - TODO
    group = Group.find(payload[:group_id])

    payload[:member_ids].each do |user_id|
      user_group = UserGroup.find_by(user_id: user_id)

      if user_group && user_group.group.enterprise == diverst_request.user.enterprise
        begin
          group.user_groups.find_by(user_id: user_id).destroy
        rescue => e
          raise BadRequestException.new(e.message)
        end
      else
        # TODO: done properly?
        raise BadRequestException.new('Membership doesnt exist')
      end
    end

    # if we made it here - were good
    track_activity(group)
    render status: 204, json: {}
  end

  private

  def action_map(action)
    case action
    when :add_members then 'add_members_to_group'
    when :remove_members then 'remove_member_from_group'
    else nil
    end
  end

  def payload
    params
      .require(:group_member)
      .permit(
        :group_id,
        member_ids: []
      )
  end
end

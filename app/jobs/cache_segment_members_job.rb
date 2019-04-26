# Calculates the members of a segment and cache them in the segment's "members" association

class CacheSegmentMembersJob < ActiveJob::Base
  queue_as :low

  def perform(segment_id)
    segment = Segment.find_by_id(segment_id)
    return if segment.nil?

    old_members = segment.members.all
    users = segment.enterprise.users.all


    ##############################################################################################################################

    # TODO: move this to bottom
    # Apply order rules if limit present
    # Order would have no effect on the segment population if limit was not present
    # Note: - not efficient at the moment - should be applied after field rules but field rules returns array
    if segment.limit.present?
      # Apply each order rule to the users list - finally apply a limit
      users = segment.order_rules.reduce(users) { |users, rule| users.order(rule.field_name => rule.operator_name) }
    end

    # Apply group scoping rules
    users = segment.group_rules.reduce(users) { |users, rule| rule.apply(users) }

    # Apply field rules
    new_members = users.select do |user|
      user.is_part_of_segment?(segment)
    end

    # Finally apply a limit if limit is set
    new_members = new_members.take(segment.limit) if segment.limit.present?


    ##############################################################################################################################

    members_to_remove = old_members - new_members
    members_to_add = new_members - old_members

    members_to_remove.each do |member|
      segment.members.delete(member)
    end

    members_to_add.each do |member|
      segment.members << member if !segment.members.where(:id => member.id).exists?
      begin
        member.__elasticsearch__.update_document # Update user in Elasticsearch to reflect their new segment
      rescue
        next
      end
    end
  end
end

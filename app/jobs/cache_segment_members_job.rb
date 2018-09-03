# Calculates the members of a segment and cache them in the segment's "members" association

class CacheSegmentMembersJob < ActiveJob::Base
  queue_as :low

  def perform(segment)
    users = segment.enterprise.users.all
    old_members = segment.members.all

    new_members = users.select do |user|
      user.is_part_of_segment?(segment)
    end

    members_to_remove = old_members - new_members
    members_to_add = new_members - old_members

    members_to_remove.each do |member|
      segment.members.delete(member)
    end

    members_to_add.each do |member|
      segment.members << member
      member.__elasticsearch__.update_document # Update user in Elasticsearch to reflect their new segment
    end
  end
end

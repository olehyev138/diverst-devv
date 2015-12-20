# Calculates the members of a segment and cache them in the segment's "members" association

class CacheSegmentMembersJob < ActiveJob::Base
  queue_as :default

  def perform(segment)
    employees = segment.enterprise.employees.all
    old_members = segment.members.all

    new_members = employees.select do |employee|
      employee.is_part_of_segment?(segment)
    end

    members_to_remove = old_members - new_members
    members_to_add = new_members - old_members

    puts "Current members:   #{old_members.length}"
    puts "Members to remove: #{members_to_remove.length}"
    puts "Members to add:    #{members_to_add.length}"

    members_to_remove.each do |member|
      segment.members.delete(member)
    end

    members_to_add.each do |member|
      segment.members << member
      member.__elasticsearch__.update_document # Update employee in Elasticsearch to reflect their new segment
    end
  end
end

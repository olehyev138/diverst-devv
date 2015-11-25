# Calculates the members of a segment and cache them in the segment's "members" association

class CacheSegmentMembersJob < ActiveJob::Base
  queue_as :default

  def perform(segment)
    employees = segment.enterprise.employees.all

    new_members = employees.select do |employee|
      employee.is_part_of_segment?(segment)
    end

    segment.members = new_members

    segment.save
  end
end

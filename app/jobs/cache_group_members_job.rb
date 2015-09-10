# Calculates the members of a group and cache them in the group's "members" association

class CacheGroupMembersJob < ActiveJob::Base
  queue_as :default

  def perform(group)
    fields = group.enterprise.fields
    employees = group.enterprise.employees.all

    new_members = employees.select do |employee|
      employee.is_part_of_group?(group)
    end

    group.members = new_members

    group.save
  end
end

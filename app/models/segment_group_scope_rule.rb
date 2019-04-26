class SegmentGroupScopeRule < BaseClass
  belongs_to :segment
  has_many :groups

  def self.operators
    {
      join: 0,
      intersect: 1
    }
  end

  def operator_name(operator)
    SegmentGroupScopeRule.operators.key(operator)
  end

  def apply(users)
    group_ids = groups.ids

    if operator == 0
      # join
      users.joins(:groups).where('group_id in (?)', group_ids)
    else
      # intersect
      user_groups_intersection(group_ids)
    end
  end

  private

  def user_groups_intersection(group_ids)
    # returns an array

    # get list of member ids for each group
    members_per_group = Group.find(group_ids).map { |g| g.members.ids }

    # run an intersection operation on every member list
    # ie get all member ids that are common between all groups
    members_per_group.reduce { |result, element| result & element }
  end
end

class SegmentGroupScopeRule < BaseClass
  belongs_to :segment
  has_many :segment_group_scope_rule_groups
  has_many :groups, through: :segment_group_scope_rule_groups

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
      users.joins(:groups).where('user_groups.group_id in (?)', group_ids)
    else
      # intersect
      user_groups_intersection(group_ids, users)
    end
  end

  private

  def user_groups_intersection(group_ids, users)
    # returns an array

    # get list of member ids for each group
    members_per_group = Group.find(group_ids).map { |g| g.members.ids.select { |id| users.ids.include?(id) } }

    # run an intersection operation on every member list
    # ie get all member ids that are common between all groups
    user_ids = members_per_group.reduce { |result, element| result & element }

    users.where(id: user_ids)
  end
end

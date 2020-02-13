class SegmentGroupScopeRule < BaseClass
  belongs_to :segment
  has_many :segment_group_scope_rule_groups
  has_many :groups, through: :segment_group_scope_rule_groups

  validates_presence_of :operator
  validate :has_at_least_one_group

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
    user_ids = users.map(&:id)

    if operator == 0
      # join
      UserGroup.where(user_id: user_ids, group_id: group_ids).map(&:user).uniq
    else
      # intersect
      user_groups_intersection(group_ids, users)
    end
  end

  private

  def has_at_least_one_group
    errors.add(:groups, 'there must be at least one group chosen') if segment_group_scope_rule_groups.empty?
  end

  def user_groups_intersection(group_ids, users)
    users = User.where(id: users.map(&:id))
    # returns an array

    # get list of member ids for each group
    members_per_group = Group.find(group_ids).map { |g| g.members.ids.select { |id| users.ids.include?(id) } }

    # run an intersection operation on every member list
    # ie get all member ids that are common between all groups
    user_ids = members_per_group.reduce { |result, element| result & element }

    users.where(id: user_ids)
  end
end

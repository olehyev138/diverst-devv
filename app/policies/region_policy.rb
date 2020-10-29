class RegionPolicy < GroupBasePolicy
  attr_reader :parent_policy

  # Hack for Scoping
  def group_visibility_setting
    'DEFINED'
  end

  def initialize(*args)
    super
    @parent_policy = GroupPolicy.new(@user, @group || Group)
  end

  def group_association; :parent end

  def group_id_param; :parent_id end

  delegate :show?, :update?, :destroy?, :manage?, to: :parent_policy

  def index?
    group.present? ? parent_policy.show? : parent_policy.index?
  end

  def create?
    parent_policy.update?
  end

  private def method_missing(symbol, *args)
    if parent_policy.respond_to?(symbol)
      parent_policy.send(symbol, *args)
    end
  end

  class Scope < Scope
    def group_base
      group.regions
    end

    def joined_with_group
      scope.left_joins(policy.group_association => [:enterprise, :user_groups, :group_leaders])
    end

    def publicly_visible
      '`groups`.`private` = FALSE AND `regions`.`private` = FALSE'
    end

    def group_visible
      '`groups`.`private` = TRUE AND `regions`.`private` = FALSE'
    end

    def leader_visible
      'TRUE'
    end

    def general_permission(permission)
      'TRUE'
    end

    def resolve
      super(nil)
    end
  end
end

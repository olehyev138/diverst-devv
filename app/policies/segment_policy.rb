class SegmentPolicy < ApplicationPolicy
  def index?
    return true if create?
    @policy_group.segments_index?
  end

  def create?
    return true if update?
    @policy_group.segments_create?
  end
  
  def manage?
    return true if manage_all?
    @policy_group.segments_manage?
  end

  def update?
    manage?
  end

  def destroy?
    manage?
  end
  
  class Scope < Scope
    
    def index?
      SegmentPolicy.new(user, nil).index?
    end
    
    def resolve
      if index?
        scope.where(:enterprise_id => user.enterprise_id)
      else
        []
      end
    end
  end

end

class MentoringInterestPolicy < ApplicationPolicy
    def index?
        return true if manage_all?
        @policy_group.mentorship_manage?
    end
    
    def edit?
        index?
    end
    
    def create?
        index?
    end
    
    def update?
        index?
    end
    
    def destroy?
        index?
    end
end

class SocialLinkPolicy < ApplicationPolicy
  
    def index?
        @policy_group.social_links_index?
    end
    
    def create?
        @policy_group.social_links_create?
    end
    
    def manage?
        return true if @policy_group.social_links_manage?
        @record.author == @user
    end
    
    def update?
        manage?
    end
    
    def destroy?
        manage?
    end
  
    class Scope < Scope 
        def index?
            SocialLinkPolicy.new(user, nil).index?
        end
    
        def resolve
            if index?
                scope.where(author_id: user.id)
            else
                []
            end
        end
    end
  
end
class PolicyGroup < ActiveRecord::Base
    # associations
    belongs_to :user, inverse_of: :policy_group
    
    validates_uniqueness_of :user
    
    def self.users_that_able_to_accept_budgets(enterprise)
        enterprise.users.select { |u| u.policy_group.groups_budgets_approve }
    end

end

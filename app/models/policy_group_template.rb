class PolicyGroupTemplate < ActiveRecord::Base
    
    # associations
    belongs_to :user_role, inverse_of: :policy_group_template, dependent: :destroy
    belongs_to :enterprise
    
    # validations
    validates :name,        presence: true
    validates :user_role,   presence: true
    validates :enterprise,  presence: true
    
    validates_uniqueness_of :name,          scope: [:enterprise]
    validates_uniqueness_of :user_role,     scope: [:enterprise]
    validates_uniqueness_of :default,       scope: [:enterprise], conditions: -> { where(default: true) }
    
    # retrieves fields for policy and returns them
    # to user object to create policy_group
    
    def create_new_policy
        return attributes.except("id", "name", "enterprise_id", "role", "default", "created_at", "updated_at", "user_role_id")
    end
    
    after_update :update_user_roles
    
    # finds users/group_leaders in the enterprise
    def update_user_roles
        PolicyGroupTemplateUpdate.perform_now(self)
    end

end

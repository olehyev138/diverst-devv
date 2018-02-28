# each user role has it's own policy_group_template
# any time a user is created, the user will have a specfic role and the
# policy_group_template for that role will be used to create the policy_group
# for that user

class UserRole < ActiveRecord::Base
    # associations
    belongs_to  :enterprise
    has_one     :policy_group_template
    
    # validations
    validates :name,                    presence: true
    validates :role_type,               presence: true
    validates :enterprise,              presence: true
    validates :policy_group_template,   presence: true
    
    validates_uniqueness_of :name,                  scope: [:enterprise]
    validates_uniqueness_of :policy_group_template, scope: [:enterprise], :on => :update
    validates_uniqueness_of :default,               scope: [:enterprise], conditions: -> { where(default: true) }
    
    # scopes
    scope :user_type,   ->  {where(:role_type => "user")}
    scope :group_type,  ->  {where(:role_type => "group")}
    
    # before the user role is created we need to create a template that
    # is tied to this role
    
    before_validation :build_default_policy_group_template
    
    def build_default_policy_group_template
        build_policy_group_template(:name => "#{name.titleize} Policy Template", :enterprise => enterprise, :default => default)
        true
    end

end
class ResetUserRoleJob < ActiveJob::Base
    queue_as :default

    def perform(user_role)
        enterprise = user_role.enterprise
    
        enterprise.users.where(:role => user_role.role_name).find_each do |user|
            default_role = enterprise.user_roles.default.role_name
            user.role = default_role
            user.save!
        end
    end
end

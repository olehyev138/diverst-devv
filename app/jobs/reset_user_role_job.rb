class ResetUserRoleJob < ActiveJob::Base
    queue_as :default

    def perform(user_role)
        enterprise = user_role.enterprise
        enterprise.users.where(:user_role_id => user_role.id).find_each do |user|
            user.user_role_id = enterprise.user_roles.default.id
            user.save!
        end
    end
end

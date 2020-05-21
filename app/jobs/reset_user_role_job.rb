class ResetUserRoleJob < ActiveJob::Base
  queue_as :default

  def perform(user_role_id, enterprise_id)
    enterprise = Enterprise.find_by_id(enterprise_id)
    return if enterprise_id.nil?

    enterprise.users.where(user_role_id: user_role_id).find_each do |user|
      user.user_role_id = enterprise.user_roles.default.id
      user.save!
    end
  end
end

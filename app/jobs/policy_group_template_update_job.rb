class PolicyGroupTemplateUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    template = PolicyGroupTemplate.find_by_id(id)
    return if id.nil?

    enterprise = template.enterprise
    user_role = template.user_role
    enterprise.users.where(user_role_id: user_role.id).find_each do |user|
      user.set_default_policy_group
    end

    GroupLeader.joins(group: :enterprise).where(groups: { enterprise_id: enterprise.id }, user_role_id: user_role.id).find_each do |leader|
      leader.set_admin_permissions
      leader.save(validate: false)
    end
  end
end

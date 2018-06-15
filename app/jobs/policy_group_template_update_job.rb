class PolicyGroupTemplateUpdateJob < ActiveJob::Base
    queue_as :default

    def perform(template)
        enterprise = template.enterprise
        user_role = template.user_role
        enterprise.users.where(:user_role_id => user_role.id).find_each do |user|
            user.set_default_policy_group
        end
        
        GroupLeader.joins(:group => :enterprise).where(:groups => {:enterprise_id => enterprise.id}, :user_role_id => user_role.id).find_each do |leader|
            leader.groups_budgets_index = template.groups_budgets_index
            leader.initiatives_manage = template.initiatives_manage
            leader.groups_manage = template.groups_manage
            leader.save!(:validate => false)
        end
    end
end

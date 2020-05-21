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
      # budgets
      leader.groups_budgets_index = template.groups_budgets_index
      leader.groups_budgets_request = template.groups_budgets_request
      leader.budget_approval = template.budget_approval
      leader.groups_budgets_manage = template.groups_budgets_manage

      # events
      leader.initiatives_index = template.initiatives_index
      leader.initiatives_manage = template.initiatives_manage
      leader.initiatives_create = template.initiatives_create

      # manage group in entirety - this permission supersedes all other permissions
      leader.groups_manage = template.groups_manage

      # members
      leader.groups_members_index = template.groups_members_index
      leader.groups_members_manage = template.groups_members_manage

      # leaders
      leader.group_leader_index = template.group_leader_index
      leader.group_leader_manage = template.group_leader_manage

      # insights
      leader.groups_insights_manage = template.groups_insights_manage

      # layouts
      leader.groups_layouts_manage = template.groups_layouts_manage

      # settings
      leader.group_settings_manage = template.group_settings_manage

      # news
      leader.news_links_index = template.news_links_index
      leader.news_links_create = template.news_links_create
      leader.news_links_manage = template.news_links_manage

      # messages
      leader.group_messages_manage = template.group_messages_manage
      leader.group_messages_index = template.group_messages_index
      leader.group_messages_create = template.group_messages_create

      # social links
      leader.social_links_manage = template.social_links_manage
      leader.social_links_index = template.social_links_index
      leader.social_links_create = template.social_links_create

      # resources
      leader.group_resources_manage = template.group_resources_manage
      leader.group_resources_index = template.group_resources_index
      leader.group_resources_create = template.group_resources_create

      # posts
      leader.group_posts_index = template.group_posts_index
      leader.manage_posts = template.manage_posts

      leader.save!(validate: false)
    end
  end
end

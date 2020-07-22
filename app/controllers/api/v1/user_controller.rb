class Api::V1::UserController < DiverstController
  def get_user_data
    render json: {
        user_id: current_user.id,
        enterprise: AuthenticatedEnterpriseSerializer.new(current_user.enterprise).as_json,
        policy_group: PolicyGroupSerializer.new(current_user.policy_group).as_json,
        email: current_user.email,
        avatar_data: AttachmentHelper.attachment_data_string(current_user.avatar),
        avatar_content_type: AttachmentHelper.attachment_content_type(current_user.avatar),
        role: current_user.user_role.role_name,
        time_zone: ActiveSupport::TimeZone.find_tzinfo(current_user.time_zone).name,
        created_at: current_user.created_at.as_json,
        permissions: {
            users_view: UserPolicy.new(current_user, User).index?,
            users_create: UserPolicy.new(current_user, User).create?,
            users_manage: UserPolicy.new(current_user, User).manage?,

            groups_view: GroupPolicy.new(current_user, Group).index?,
            groups_create: GroupPolicy.new(current_user, Group).create?,
            groups_manage: GroupPolicy.new(current_user, Group).manage?,
            groups_calendars: GroupPolicy.new(current_user, Group).calendar?,

            news_view: NewsFeedLinkPolicy.new(current_user, NewsFeedLink).index?,
            events_view: InitiativePolicy.new(current_user, Initiative).index?,

            segments_view: SegmentPolicy.new(current_user, Segment).index?,
            segments_create: SegmentPolicy.new(current_user, Segment).create?,
            segments_manage: SegmentPolicy.new(current_user, Segment).manage?,

            campaigns_view: CampaignPolicy.new(current_user, Campaign).index?,
            campaigns_create: CampaignPolicy.new(current_user, Campaign).create?,
            campaigns_manage: CampaignPolicy.new(current_user, Campaign).manage?,

            polls_view: PollPolicy.new(current_user, Poll).index?,
            polls_create: PollPolicy.new(current_user, Poll).create?,
            polls_manage: PollPolicy.new(current_user, Poll).manage?,

            enterprise_folders_view: EnterpriseFolderPolicy.new(current_user, Folder).index?,
            enterprise_folders_create: EnterpriseFolderPolicy.new(current_user, Folder).create?,

            mentoring_interests_view: MentoringInterestPolicy.new(current_user, MentoringInterest).index?,
            mentoring_interests_create: MentoringInterestPolicy.new(current_user, MentoringInterest).create?,
            mentoring_interests_manage: MentoringInterestPolicy.new(current_user, MentoringInterest).update?,

            logs_view: LogPolicy.new(current_user, nil).index?,
            logs_create: LogPolicy.new(current_user, nil).create?,
            logs_manage: LogPolicy.new(current_user, nil).update?,

            policy_templates_view: PolicyGroupTemplatePolicy.new(current_user, PolicyGroupTemplate).index?,
            policy_templates_create: PolicyGroupTemplatePolicy.new(current_user, PolicyGroupTemplate).create?,
            policy_templates_manage: PolicyGroupTemplatePolicy.new(current_user, PolicyGroupTemplate).update?,

            metrics_overview: MetricsDashboardPolicy.new(current_user, MetricsDashboard).index?,
            metrics_create: MetricsDashboardPolicy.new(current_user, MetricsDashboard).create?,

            sso_authentication: EnterprisePolicy.new(current_user, current_user.enterprise).sso_manage?,
            fields_manage: EnterprisePolicy.new(current_user, current_user.enterprise).edit_fields?,
            branding_manage: EnterprisePolicy.new(current_user, current_user.enterprise).manage_branding?,
            custom_text_manage: EnterprisePolicy.new(current_user, current_user.enterprise).manage_branding?,
            emails_manage: EnterprisePolicy.new(current_user, current_user.enterprise).manage_branding?,
            integrations_manage: EnterprisePolicy.new(current_user, current_user.enterprise).sso_manage?,
            rewards_manage: EnterprisePolicy.new(current_user, current_user.enterprise).diversity_manage?,
            archive_manage: EnterprisePolicy.new(current_user, current_user.enterprise).auto_archive_settings_manage?,
            posts_manage: EnterprisePolicy.new(current_user, current_user.enterprise).manage_posts?,
            enterprise_manage: EnterprisePolicy.new(current_user, []).enterprise_manage?,
            manage_all_budgets: BudgetPolicy.new(current_user, []).manage_all_budgets?,

            edit_posts: GroupPolicy.new(current_user, Group).manage_all_groups? && EnterprisePolicy.new(current_user, current_user.enterprise).manage_posts?,
        }
    }
  end

  def get_posts
    render json: current_user.posts(params)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def get_downloads
    render json: diverst_request.user.downloads(params)
  rescue => e
    raise BadRequestException.new(e.message)
  end
end

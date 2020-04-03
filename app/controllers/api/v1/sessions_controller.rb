class Api::V1::SessionsController < DiverstController
  skip_before_action :verify_jwt_token, only: [:create, :logout]

  def create
    user = User.signin(params[:email], params[:password])

    render status: 200, json: {
      token: UserTokenService.create_jwt(user, params),
      user_id: user.id,
      enterprise: AuthenticatedEnterpriseSerializer.new(user.enterprise).as_json,
      policy_group: PolicyGroupSerializer.new(user.policy_group).as_json,
      email: user.email,
      role: user.user_role.role_name,
      time_zone: ActiveSupport::TimeZone.find_tzinfo(user.time_zone).name,
      created_at: user.created_at.as_json,
      permissions: {
          users_view: UserPolicy.new(user, User).index?,
          users_create: UserPolicy.new(user, User).create?,
          users_manage: UserPolicy.new(user, User).manage?,

          groups_view: GroupPolicy.new(user, Group).index?,
          groups_create: GroupPolicy.new(user, Group).create?,
          groups_manage: GroupPolicy.new(user, Group).manage?,
          groups_calendars: GroupPolicy.new(user, Group).calendar?,

          segments_view: SegmentPolicy.new(user, Segment).index?,
          segments_create: SegmentPolicy.new(user, Segment).create?,
          segments_manage: SegmentPolicy.new(user, Segment).manage?,

          campaigns_view: CampaignPolicy.new(user, Campaign).index?,
          campaigns_create: CampaignPolicy.new(user, Campaign).create?,
          campaigns_manage: CampaignPolicy.new(user, Campaign).manage?,

          polls_view: PollPolicy.new(user, Poll).index?,
          polls_create: PollPolicy.new(user, Poll).create?,
          polls_manage: PollPolicy.new(user, Poll).manage?,

          enterprise_folders_view: EnterpriseFolderPolicy.new(user, Folder).index?,
          enterprise_folders_create: EnterpriseFolderPolicy.new(user, Folder).create?,

          mentoring_interests_view: MentoringInterestPolicy.new(user, MentoringInterest).index?,
          mentoring_interests_create: MentoringInterestPolicy.new(user, MentoringInterest).create?,
          mentoring_interests_manage: MentoringInterestPolicy.new(user, MentoringInterest).update?,

          logs_view: LogPolicy.new(user, nil).index?,
          logs_create: LogPolicy.new(user, nil).create?,
          logs_manage: LogPolicy.new(user, nil).update?,

          policy_templates_view: PolicyGroupTemplatePolicy.new(user, PolicyGroupTemplate).index?,
          policy_templates_create: PolicyGroupTemplatePolicy.new(user, PolicyGroupTemplate).create?,
          policy_templates_manage: PolicyGroupTemplatePolicy.new(user, PolicyGroupTemplate).update?,

          metrics_overview: MetricsDashboardPolicy.new(user, MetricsDashboard).index?,
          metrics_create: MetricsDashboardPolicy.new(user, MetricsDashboard).create?,

          sso_authentication: EnterprisePolicy.new(user, user.enterprise).sso_manage?,
          fields_manage: EnterprisePolicy.new(user, user.enterprise).edit_fields?,
          branding_manage: EnterprisePolicy.new(user, user.enterprise).manage_branding?,
          custom_text_manage: EnterprisePolicy.new(user, user.enterprise).manage_branding?,
          emails_manage: EnterprisePolicy.new(user, user.enterprise).manage_branding?,
          integrations_manage: EnterprisePolicy.new(user, user.enterprise).sso_manage?,
          rewards_manage: EnterprisePolicy.new(user, user.enterprise).diversity_manage?,

          edit_posts: GroupPolicy.new(user, Group).manage_all_groups? && EnterprisePolicy.new(user, user.enterprise).manage_posts?,
      }
    }
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def logout
    render status: 200, json: klass.logout(request.headers['Diverst-UserToken'])
  rescue => e
    raise BadRequestException.new(e.message)
  end
end

class Api::V1::UsersController < DiverstController
  skip_before_action :verify_jwt_token, only: [
      :find_user_enterprise_by_email,
      :sign_up_token,
      :sign_up,
      :reset_password_request,
      :reset_password_token,
      :password_reset,
  ]

  def find_user_enterprise_by_email
    render json: User.find_user_by_email(self.diverst_request.user, params).enterprise
  end

  def index
    base_authorize(klass)

    render status: 200, json: klass.index(self.diverst_request, params.permit!), use_serializer: serializer(params)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def budget_approvers
    raise InvalidInputException.new(
        {
            message: 'Cannot look for budget approver with a group id',
            attribute: :group_id
        }) unless params[:group_id]

    base_authorize(klass)

    base = User.left_joins(:policy_group, :group_leaders, :user_groups)
                .where(
                    [
                        '(`group_leaders`.`budget_approval` = TRUE AND `group_leaders`.`group_id` = ?)',
                        '(`policy_groups`.`budget_approval` = TRUE AND `policy_groups`.`groups_manage` = TRUE)',
                        '(`policy_groups`.`budget_approval` = TRUE AND `user_groups`.`group_id` = ?)',
                        '(`policy_groups`.`manage_all` = TRUE)',
                    ].join(' OR '), params[:group_id], params[:group_id])

    render status: 200, json: klass.index(self.diverst_request, params.permit!, base: base)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def create
    params[klass.symbol] = admin_payload
    base_authorize(klass)
    user = klass.build(self.diverst_request, params)
    user.invite!

    render status: 201, json: user
  rescue => e
    case e
    when InvalidInputException, Pundit::NotAuthorizedError then raise
    else raise BadRequestException.new(e.message)
    end
  end

  def show
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: klass.show(self.diverst_request, params), serializer: serializer(params)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def update
    if current_user.policy_group.users_manage
      params[klass.symbol] = admin_payload
    else
      params[klass.symbol] = profile_update_payload
    end
    item = klass.find(params[:id])
    base_authorize(item)
    item.avatar.purge_later if item.avatar.attached? && params[:avatar].blank?

    updated_item = klass.update(self.diverst_request, params)
    track_activity(updated_item)

    # when the Email has been modified
    if item.email != updated_item.email
      DiverstMailer.old_email_update(item.id, item.email).deliver_later
      DiverstMailer.new_email_update(updated_item.id, updated_item.email).deliver_later
    end

    render status: 200, json: updated_item, serializer: serializer(params)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  def index_except_user
    item = klass.find(params[:id])
    # base_authorize(item)

    render status: 200, json: item.index_except_self(params, serializer: serializer(params))
  rescue => e
    raise BadRequestException.new(e)
  end

  def serializer(params)
    case params[:serializer]
    when 'mentorship'
      UserMentorshipSerializer
    when 'mentorship_lite'
      UserMentorshipLiteSerializer
    else
      nil
    end
  end

  def prototype
    item = current_user.enterprise

    base_authorize(klass)

    render status: 200, json: klass.create_prototype(item)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  # ===============================================
  # TOKEN CODE
  # ===============================================

  private def token(token_service, with_associations: false, groups: false)
    token, user = token_service.form_token(params[:token])

    groups_scope = if groups
      Group
          .preload(Group.base_preloads(Request.create_request(user, action: 'index', with_children: true)))
          .where(parent_id: nil, private: false, enterprise_id: user.enterprise_id)
    else
      Group.none
    end

    render status: 200, json: {
        token: token,
        user: InvitedUserSerializer.new(user, with_associations: with_associations).as_json,
        groups: groups_scope.map do |group|
          GroupOnboardingSerializer.new(group, scope: { current_user: user }).as_json
        end
    }
  rescue => e
    raise BadRequestException.new(e.message)
  end

  # ================================================
  # SIGN IN CODE
  # ================================================

  def sign_up_token
    token(InviteTokenService, groups: true, with_associations: true)
  end

  def sign_up
    user = InviteTokenService.verify_jwt_token(params[:token], 'set_password')

    render status: 200, json: user.sign_up(sign_up_payload)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  def sign_up_payload
    params
        .require(:user)
        .permit(
            :password,
            :password_confirmation,
            :first_name,
            :last_name,
            :biography,
            :time_zone,
            group_ids: [],
            field_data_attributes: [
                :id,
                :field_id,
                :data,
            ]
          )
  end

  # ================================================
  # PASSWORD RESET CODE
  # ================================================

  def reset_password_request
    user = User.find_user_by_email(self.diverst_request.user, params)
    raise RuntimeException.new('User not initialized') unless user&.invitation_accepted_at

    user.request_password_reset!
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def reset_password_token
    token(PasswordResetTokenService)
  end

  def password_reset
    user = PasswordResetTokenService.verify_jwt_token(params[:token], 'set_new_password')

    render status: 200, json: user.reset_password(sign_up_payload)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  def new_password_payload
    params
        .require(:user)
        .permit(
            :password,
            :password_confirmation,
          )
  end

  def admin_payload
    params
        .require(:user)
        .permit(
            :avatar,
            :email,
            :first_name,
            :last_name,
            :biography,
            :active,
            :time_zone,
            :user_role_id,
            :groups_notifications_frequency,
            :groups_notifications_date,
            :custom_policy_group,
            :mentor,
            :mentee,
            :linkedin_profile_url,
            :accepting_mentee_requests,
            :accepting_mentor_requests,
            :active,
            :mentorship_description,
            mentoring_interest_ids: [],
            mentoring_type_ids: [],
            policy_group_attributes: [
                :campaigns_index,
                :campaigns_create,
                :campaigns_manage,
                :events_index,
                :events_create,
                :events_manage,
                :polls_index,
                :polls_create,
                :polls_manage,
                :group_messages_index,
                :group_messages_create,
                :group_messages_manage,
                :groups_index,
                :groups_create,
                :groups_manage,
                :groups_members_manage,
                :groups_members_index,
                :metrics_dashboards_index,
                :metrics_dashboards_create,
                :news_links_index,
                :news_links_create,
                :news_links_manage,
                :enterprise_resources_index,
                :enterprise_resources_create,
                :enterprise_resources_manage,
                :segments_index,
                :segments_create,
                :segments_manage,
                :users_index,
                :users_manage,
                :initiatives_index,
                :initiatives_create,
                :initiatives_manage,
                :budget_approval,
                :logs_view,
                :groups_budgets_index,
                :groups_budgets_request,
                :budget_approval,
                :group_leader_manage,
                :sso_manage,
                :permissions_manage,
                :diversity_manage,
                :manage_posts,
                :branding_manage,
                :global_calendar,
                :manage_all,
                :enterprise_manage,
                :groups_budgets_manage,
                :group_leader_index,
                :groups_insights_manage,
                :groups_layouts_manage,
                :group_resources_index,
                :group_resources_create,
                :group_resources_manage,
                :social_links_index,
                :social_links_create,
                :social_links_manage,
                :group_settings_manage,
                :group_posts_index,
                :mentorship_manage
            ]
          )
  end

  def payload
    params
      .require(:user)
      .permit(
        :avatar,
        :email,
        :first_name,
        :last_name,
        :biography,
        :time_zone,
        :user_role_id,
        :groups_notifications_frequency,
        :groups_notifications_date,
        :custom_policy_group,
        :mentor,
        :mentee,
        :linkedin_profile_url,
        :accepting_mentee_requests,
        :accepting_mentor_requests,
        :mentorship_description,
        mentoring_interest_ids: [],
        mentoring_type_ids: [],
      )
  end

  def profile_update_payload
    params
        .require(:user)
        .permit(
            :avatar,
            :first_name,
            :last_name,
            :biography,
            :time_zone,
            :user_role_id,
            :groups_notifications_frequency,
            :groups_notifications_date,
            :custom_policy_group,
            :mentor,
            :mentee,
            :linkedin_profile_url,
            :accepting_mentee_requests,
            :accepting_mentor_requests,
            :mentorship_description,
            mentoring_interest_ids: [],
            mentoring_type_ids: [],
          )
  end

  def sample_csv
    authorize User, :index?
    send_data current_user.enterprise.users_csv(5), filename: 'diverst_import.csv'
  end

  private

  def model_map(model)
    if action_name == 'export_csv'
      current_user
    else
      model
    end
  end

  def action_map(action)
    case action
    when :update then 'update_mentorship_profile' if params[:serializer] == 'mentorship'
    when :create then 'create'
    when :export_csv then 'export_csv'
    else nil
    end
  end
end

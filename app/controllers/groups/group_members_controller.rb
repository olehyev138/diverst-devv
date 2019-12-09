class Groups::GroupMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_member, only: [:destroy, :accept_pending, :remove_member]
  before_action :set_user, only: [:show, :edit, :update]
  after_action :verify_authorized
  after_action :visit_page, only: [:index, :show]

  layout 'erg'

  def index
    authorize [@group], :view_members?, policy_class: GroupMemberPolicy
    @q = User.ransack(params[:q])
    @total_members = @group.active_members.count
    @members = @group.filtered_member_list(params[:q] || {})
    @segments = @group.enterprise.segments
    respond_to do |format|
      format.html
      format.json { render json: GroupMemberDatatable.new(view_context, @group, @members) }
    end
  end

  def pending
    authorize [@group], :update?, policy_class: GroupMemberPolicy

    @pending_members = @group.pending_members.page(params[:page])
  end

  def accept_pending
    authorize [@group], :update?, policy_class: GroupMemberPolicy

    @group.accept_user_to_group(@member)
    track_activity(@member, :accept_pending, params = { group: @group })

    redirect_to action: :pending
  end

  def new
    # TODO only show enterprise users not currently in group
    authorize [@group], :create?, policy_class: GroupMemberPolicy
  end

  # Removes a member from the group
  def destroy
    authorize [@group, @member], :destroy?, policy_class: GroupMemberPolicy
    @group.user_groups.find_by(user_id: @member.id).destroy
    redirect_to group_path(@group)
  end

  def create
    authorize [@group, current_user], :create?, policy_class: GroupMemberPolicy
    @group_member = @group.user_groups.new(group_member_params)
    @group_member.accepted_member = @group.pending_users.disabled?

    if @group_member.save
      WelcomeNotificationJob.perform_later(@group.id, current_user.id)
      flash[:notice] = 'You are now a member'


      if @group.default_mentor_group?
        redirect_to edit_user_mentorship_url(id: current_user.id)
      # If group has survey questions - redirect user to answer them
      elsif @group.survey_fields.present?
        respond_to do |format|
          format.html { redirect_to survey_group_questions_path(@group) }
          format.js
        end
      else
        respond_to do |format|
          format.html { @group.is_sub_group? ? redirect_to(:back) : redirect_to(group_path(@group)) }
          format.js
        end
      end
    else
      flash[:notice] = 'The member was not created. Please fix the errors'
      respond_to do |format|
        format.html { render :new }
        format.js
      end
    end
  end

  def show
    authorize [@group, @user], :update?, policy_class: GroupMemberPolicy
  end

  def edit
    authorize [@group, @user], :update?, policy_class: GroupMemberPolicy
    @is_admin_view = true
  end

  def update
    authorize [@group, @user], :update?, policy_class: GroupMemberPolicy

    @user.assign_attributes(user_params)
    @user.info.merge(fields: @user.enterprise.fields, form_data: params['custom-fields'])

    if @user.save
      flash[:notice] = 'Your user was updated'
      redirect_to :back
    else
      flash[:alert] = 'Your user was not updated. Please fix the errors'
      render :edit
    end
  end

  def add_members
    authorize [@group], :create?, policy_class: GroupMemberPolicy

    add_members_params[:member_ids].each do |user_id|
      user = User.find_by_id(user_id)

      # Only add association if user exists and belongs to the same enterprise
      next if (!user) || (user.enterprise != @group.enterprise)
      next if UserGroup.where(user_id: user_id, group_id: @group.id).exists?

      UserGroup.create(group_id: @group.id, user_id: user.id, accepted_member: @group.pending_users.disabled?)
    end

    track_activity(@group, :add_members_to_group)
    redirect_to action: 'index'
  end

  def remove_member
    authorize [@group, @member], :destroy?, policy_class: GroupMemberPolicy

    @group.members.destroy(@member)
    track_activity(@group, :remove_member_from_group)
    redirect_to action: :index
  end

  def join_all_sub_groups
    authorize [@group, current_user], :create?, policy_class: GroupMemberPolicy

    @group.children.pluck(:id).each do |sub_group_id|
      unless UserGroup.where(user_id: current_user.id, group_id: sub_group_id).any?
        user_group = UserGroup.new(user_id: current_user.id, group_id: sub_group_id, accepted_member: @group.pending_users.disabled?)
        user_group.save
      end
    end

    flash[:notice] = "You've joined all #{c_t(:sub_erg).pluralize} of #{@group.name}"
    if @group.survey_fields.present?
      redirect_to survey_group_questions_path(@group)
    else
      redirect_to group_path(@group)
    end
  end

  def view_sub_groups
    authorize [@group, current_user], :create?, policy_class: GroupMemberPolicy
    @sub_groups = @group.children

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def join_sub_group
    authorize [@group, current_user], :create?, policy_class: GroupMemberPolicy
    if @group.user_groups.where(user_id: current_user.id).any?
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    else
      @group_member = @group.user_groups.new(user_id: current_user.id)
      @group_member.accepted_member = @group.pending_users.disabled?

      if @group_member.save
        WelcomeNotificationJob.perform_later(@group.id, current_user.id)
        respond_to do |format|
          format.html { redirect_to :back }
          format.js
        end
      else
        respond_to do |format|
          format.html { redirect_to :back }
          format.js
        end
      end
    end
  end

  def leave_sub_group
    authorize [@group, current_user], :destroy?, policy_class: GroupMemberPolicy
    @group.user_groups.find_by(user_id: current_user.id).destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def export_group_members_list_csv
    authorize [@group], :export_group_members_list_csv?, policy_class: GroupMemberPolicy
    export_csv_params = params[:export_csv_params]
    GroupMemberListDownloadJob.perform_later(current_user.id, @group.id, export_csv_params)
    track_activity(@group, :export_member_list)
    flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
    redirect_to :back
  end

  def view_list_of_sub_groups_for_export
    authorize [@group], :index?, policy_class: GroupMemberPolicy
    @sub_groups = @group.children

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def export_sub_groups_members_list_csv
    authorize [@group], :update?, policy_class: GroupMemberPolicy

    if params['groups'].nil?
      flash[:notice] = 'no group was selected for download'
      redirect_to :back
    else
      groups = Group.where(id: params['groups'].values, enterprise_id: current_user.enterprise_id)
      groups.each { |group| GroupMemberListDownloadJob.perform_later(current_user.id, group.id, '') }
      track_activity(@group, :export_sub_groups_members_list)
      flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
      redirect_to :back
    end
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_member
    @member = @group.members.find(params[:id])
  end

  def set_user
    @user = User.find(params[:id])
  end

  def group_member_params
    params.require(:user).permit(
      :user_id
    )
  end

  def add_members_params
    params.require(:group).permit(
      member_ids: []
    )
  end

  def user_params
    params.require(:user).permit(
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
      policy_group_attributes: [
        :id,
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

  private

  def options_to_leave_sub_groups_or_parent_group_service
    GroupMembership::Options.new(@group, current_user).leave_sub_groups_or_parent_group
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      "#{@group.to_label}'s Member List"
    when 'show'
      "#{@group.to_label} Member: #{@user.to_label}"
    when 'pending'
      "#{@group.to_label}'s Pending Member List"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end

class Groups::GroupMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_member, only: [:edit, :update, :destroy,:accept_pending, :remove_member]
  after_action :verify_authorized

  layout 'erg'

  def index
    authorize [@group], :view_members?, :policy_class => GroupMemberPolicy
    @q = User.ransack(params[:q])
    @total_members = @group.active_members.count
    @members = @group.active_members.ransack(params[:q]).result.uniq
    @segments = @group.enterprise.segments
    respond_to do |format|
      format.html
      format.json { render json: GroupMemberDatatable.new(view_context, @group, @members) }
    end
  end

  def pending
    authorize [@group], :update?, :policy_class => GroupMemberPolicy

    @pending_members = @group.pending_members.page(params[:page])
  end

  def accept_pending
    authorize [@group], :update?, :policy_class => GroupMemberPolicy

    @group.accept_user_to_group(@member)
    track_activity(@member, :accept_pending, params = { group: @group})

    redirect_to action: :pending
  end

  def new
    #TODO only show enterprise users not currently in group
    authorize [@group], :create?, :policy_class => GroupMemberPolicy
  end

  # Removes a member from the group
  def destroy
    authorize [@group, @member], :destroy?, :policy_class => GroupMemberPolicy
    @group.user_groups.find_by(user_id: @member.id).destroy
    redirect_to group_path(@group)
  end

  def create
    authorize [@group, current_user], :create?, :policy_class => GroupMemberPolicy
    @group_member = @group.user_groups.new(group_member_params)
    @group_member.accepted_member = @group.pending_users.disabled?

    if @group_member.save
      flash[:notice] = "You are now a member"
      
      if @group.default_mentor_group?
        redirect_to edit_user_mentorship_url(:id => current_user.id)
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
      flash[:notice] = "The member was not created. Please fix the errors"
      respond_to do |format|
        format.html { render :new }
        format.js
      end
    end
  end

  def add_members
    authorize [@group], :create?, :policy_class => GroupMemberPolicy

    add_members_params[:member_ids].each do |user_id|
      user = User.find_by_id(user_id)

      # Only add association if user exists and belongs to the same enterprise
      next if (!user) || (user.enterprise != @group.enterprise)
      next if policy(@group).is_a_member?

      @group.members << user
    end

    redirect_to action: 'index'
  end

  def remove_member
    authorize [@group, @member], :destroy?, :policy_class => GroupMemberPolicy

    @group.members.destroy(@member)
    redirect_to action: :index
  end

  def join_all_sub_groups
    authorize [@group], :index?, :policy_class => GroupMemberPolicy

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
    authorize [@group], :index?, :policy_class => GroupMemberPolicy
    @sub_groups = @group.children

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def join_sub_group
    authorize [@group], :destroy?, :policy_class => GroupMemberPolicy
    if @group.user_groups.where(user_id: current_user.id).any?
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    else
      @group_member = @group.user_groups.new(user_id: current_user.id)
      @group_member.accepted_member = @group.pending_users.disabled?

      if @group_member.save
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
    authorize [@group], :destroy?, :policy_class => GroupMemberPolicy
    @group.user_groups.find_by(user_id: current_user.id).destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def export_group_members_list_csv
    authorize [@group], :update?, :policy_class => GroupMemberPolicy
    GroupMemberListDownloadJob.perform_later(current_user.id, @group.id)
    flash[:notice] = "Please check your email in a couple minutes"
    redirect_to :back
  end

  protected

  def set_group
    current_user ? @group = current_user.enterprise.groups.find(params[:group_id]) : user_not_authorized
  end

  def set_member
    @member = @group.members.find(params[:id])
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

  private

  def options_to_leave_sub_groups_or_parent_group_service
    GroupMembership::Options.new(@group, current_user).leave_sub_groups_or_parent_group
  end
end

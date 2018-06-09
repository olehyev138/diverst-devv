class PolicyGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_policy_group, only: [:edit, :update, :destroy, :add_users]

  layout 'global_settings'

  def index
    authorize PolicyGroup

    @policy_groups = current_user.enterprise.policy_groups
  end

  def new
    authorize PolicyGroup

    @policy_group = current_user.enterprise.policy_groups.new
  end

  def create
    authorize PolicyGroup

    @policy_group = current_user.enterprise.policy_groups.new(policy_group_params)

    if @policy_group.save
      flash[:notice] = "Your policy group was created"
      redirect_to action: :index
    else
      flash[:alert] = "Your policy group was not created. Please fix the errors"
      render :new
    end
  end

  def update
    authorize PolicyGroup

    if params[:commit] === "Add User(s)"
      add_users
    end

    if @policy_group.update(policy_group_params)
      flash[:notice] = "Your policy group was updated"
      redirect_to action: :index
    else
      flash[:alert] = "Your policy group was not updated. Please fix the errors"
      render :edit
    end
  end

  def destroy
    authorize PolicyGroup
    @policy_group.destroy
    redirect_to action: :index
  end

  def add_users
    @policy_group.user_ids = @policy_group.user_ids + params[:policy_group][:new_users]
  end

  protected

  def set_policy_group
    if current_user
      @policy_group = current_user.enterprise.policy_groups.find(params[:id])
    else
      user_not_authorized
    end
  end

  def policy_group_params
    params
      .require(:policy_group)
      .permit(
        :name,
        :default_for_enterprise,
        :admin_pages_view,

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
        :global_settings_manage,
        :initiatives_index,
        :initiatives_create,
        :initiatives_manage,
        :budget_approval,
        :logs_view,
        :groups_budgets_index,
        :groups_budgets_request,
        :annual_budget_manage,
        user_ids: []
      )
  end
end

class PolicyGroupsController < ApplicationController
  before_action :set_policy_group, only: [:edit, :update, :destroy]

  layout 'global_settings'

  def index
    @policy_groups = current_user.enterprise.policy_groups
  end

  def new
    @policy_group = current_user.enterprise.policy_groups.new
  end

  def create
    @policy_group = current_user.enterprise.policy_groups.new(policy_group_params)

    if @policy_group.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def update
    if @policy_group.update(policy_group_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @policy_group.destroy
    redirect_to action: :index
  end

  protected

  def set_policy_group
    @policy_group = current_user.enterprise.policy_groups.find(params[:id])
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
        user_ids: []
      )
  end
end
